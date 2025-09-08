package com.cafein.menu;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cafein.menu.mapper.MenuMapper;

import javax.annotation.Resource;
import java.util.Date;
import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {

    @Resource
    private MenuMapper menuMapper;
    @Resource
    private S3Uploader s3Uploader;

    @Override
    public List<MenuDTO> getAllMenus() {
        return menuMapper.findAll();
    }
    @Override
    public MenuDTO getMenuById(Long menuId) {
        return menuMapper.findById(menuId);
    }
    
    @Override
    public void createMenu(MenuDTO dto, MultipartFile imageFile) throws Exception {
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageUrl = s3Uploader.upload(imageFile, "menu");
            dto.setMenuPictureUrl(imageUrl);
        }
        dto.setCreatedDate(new Date());
        dto.setModifiedDate(new Date());
        menuMapper.createMenu(dto);
    }

    @Override
    public List<MenuDTO> findAll() {
        return menuMapper.findAllMenus();
    }

    @Override
    public MenuDTO findById(Long id) {
        return menuMapper.findMenuById(id);
    }

    @Override
    public void updateMenu(MenuDTO dto, MultipartFile imageFile) throws Exception {
        // 새 이미지를 업로드한 경우에만 URL 갱신
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageUrl = s3Uploader.upload(imageFile, "menu");
            dto.setMenuPictureUrl(imageUrl);
        }
        // 이미지가 없으면 mapper의 <if> 조건 때문에 해당 컬럼은 갱신하지 않음
        menuMapper.updateMenu(dto);
    }

    @Override
    public void deleteMenu(Long id) {
        // 1) 먼저 메뉴 정보 조회해서 이미지 URL 확보
        MenuDTO menu = menuMapper.findMenuById(id);

        // 2) DB 삭제
        menuMapper.deleteMenu(id);

        // 3) 이미지가 있으면 S3에서도 삭제(베스트에포트)
        if (menu != null && menu.getMenuPictureUrl() != null && !menu.getMenuPictureUrl().isEmpty()) {
            try {
                // S3Uploader 가 URL을 받아 내부에서 key 추출 후 삭제함
                s3Uploader.delete(menu.getMenuPictureUrl());
            } catch (Exception e) {
                // 이미지가 남아도 서비스 동작엔 영향 없게 로그만
                System.err.println("S3 이미지 삭제 실패: " + e.getMessage());
            }
        }
    }
}
