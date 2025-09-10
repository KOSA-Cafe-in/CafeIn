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
        // 1) 이미지 URL 확보
        MenuDTO menu = menuMapper.findMenuById(id);

        // 2) DB 소프트 삭제
        int rows = menuMapper.deleteMenu(id);
        if (rows <= 0) return; // 해당 ID 없거나 이미 삭제 상태

        // 3) S3 실제 삭제(베스트 에포트)
        if (menu != null && menu.getMenuPictureUrl() != null && !menu.getMenuPictureUrl().isEmpty()) {
            try {
                s3Uploader.delete(menu.getMenuPictureUrl()); // 파일 URL 넘기는 버전
            } catch (Exception e) {
                // 이미지가 남아도 서비스엔 영향 없도록 로그만
                System.err.println("S3 이미지 삭제 실패: " + e.getMessage());
            }
        }
    }
}
