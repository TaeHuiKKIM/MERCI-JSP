package my.model;

import java.util.Date;

public class Cloth {
	private int id;
	private String title;
	private String maker;
	private int price;
	private String img_body;
	private String img_front;
	private String img_back;
	private String img_detail;
	private String description;
	private int stock;
	private String sizes;
	private String colors;
	private String clothType;
	private int freq;
	private Date openDate;	

	public Cloth() {
	} // 기본생성자

	public Cloth(String title, String maker, int price, int freq, Date openDate, String clothType, String img_body,
			String img_front, String img_back, String description, String img_detail, int stock, String sizes,
			String colors) {
		super();
		this.title = title;
		this.maker = maker;
		this.price = price;
		this.img_body = img_body;
		this.img_front = img_front;
		this.img_back = img_back;
		this.img_detail = img_detail;
		this.description = description;
		this.stock = stock;
		this.sizes = sizes;
		this.colors = colors;
		this.freq = freq;
		this.openDate = openDate;
		this.clothType = clothType;
	}

	public String getImg_body() {
		return img_body;
	}

	public void setImg_body(String img_body) {
		this.img_body = img_body;
	}

	public String getImg_front() {
		return img_front;
	}

	public void setImg_front(String img_front) {
		this.img_front = img_front;
	}

	public String getImg_back() {
		return img_back;
	}

	public void setImg_back(String img_back) {
		this.img_back = img_back;
	}

	public String getImg_detail() {
		return img_detail;
	}

	public void setImg_detail(String img_detail) {
		this.img_detail = img_detail;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public String getSizes() {
		return sizes;
	}

	public void setSizes(String sizes) {
		this.sizes = sizes;
	}

	public String getColors() {
		return colors;
	}

	public void setColors(String colors) {
		this.colors = colors;
	}

	public String getClothType() {
		return clothType;
	}

	public void setClothType(String clothType) {
		this.clothType = clothType;
	}

	public int getFreq() {
		return freq;
	}

	public void setFreq(int freq) {
		this.freq = freq;
	}

	public Date getOpenDate() {
		return openDate;
	}

	public void setOpenDate(Date openDate) {
		this.openDate = openDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getMaker() {
		return maker;
	}

	public void setMaker(String maker) {
		this.maker = maker;
	}

	public int getPrice() {
		return price;
	}

	public void setPrice(int price) {
		this.price = price;
	}

}
