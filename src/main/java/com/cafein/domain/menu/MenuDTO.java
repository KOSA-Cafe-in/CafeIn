package com.cafein.domain.menu;

public class MenuDTO {
    private int menuId;
    private String menuName;
    private String description;
    private int price;
    private String imageUrl;
    private String category;
    private boolean available;

    public MenuDTO() {}

    public MenuDTO(int menuId, String menuName, String description, int price, String imageUrl, String category, boolean available) {
        this.menuId = menuId;
        this.menuName = menuName;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.category = category;
        this.available = available;
    }

    // Getters and Setters
    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    @Override
    public String toString() {
        return "MenuDTO{" +
                "menuId=" + menuId +
                ", menuName='" + menuName + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", imageUrl='" + imageUrl + '\'' +
                ", category='" + category + '\'' +
                ", available=" + available +
                '}';
    }
}