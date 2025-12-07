package my.model;

import java.util.Date;

public class Cloth {
	private int id;
	private String title;
	private String maker;
	private int price;
	private String imgBody;
	private String imgFront;
	private String imgBack;
	private String imgDetail;
	private String description;
	private int stock;
	private String sizes;
	private String colors;
	private String clothType;
	private int freq;
	private Date openDate;	

	public Cloth() {
	} // 기본생성자

	public Cloth(String title, String maker, int price, int freq, Date openDate, String clothType, String imgBody,
			String imgFront, String imgBack, String description, String imgDetail, int stock, String sizes,
			String colors) {
		super();
		this.title = title;
		this.maker = maker;
		this.price = price;
		this.imgBody = imgBody;
		this.imgFront = imgFront;
		this.imgBack = imgBack;
		this.imgDetail = imgDetail;
		this.description = description;
		this.stock = stock;
		this.sizes = sizes;
		this.colors = colors;
		this.freq = freq;
		this.openDate = openDate;
		this.clothType = clothType;
	}

	public String getImgBody() {
		return imgBody;
	}

	public void setImgBody(String imgBody) {
		this.imgBody = imgBody;
	}

	public String getImgFront() {
		return imgFront;
	}

	public void setImgFront(String imgFront) {
		this.imgFront = imgFront;
	}

	public String getImgBack() {
		return imgBack;
	}

	public void setImgBack(String imgBack) {
		this.imgBack = imgBack;
	}

	public String getImgDetail() {
		return imgDetail;
	}

	public void setImgDetail(String imgDetail) {
		this.imgDetail = imgDetail;
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