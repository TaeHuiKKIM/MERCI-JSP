package my.model;
import java.util.Date;

public class Cloth {
	private int id;
	private String title;
	private String maker;
	private int price;
	private String poster;
	private int freq;
	private Date openDate;
	private String clothType;
	
	public Cloth() {} //기본생성자

	public Cloth(String title, String maker, int price, String poster, int freq, Date openDate, String clothType) {
		super();
		this.title = title;
		this.maker = maker;
		this.price = price;
		this.poster = poster;
		this.freq = freq;
		this.openDate = openDate;
		this.clothType = clothType;
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

	public String getPoster() {
		return poster;
	}

	public void setPoster(String poster) {
		this.poster = poster;
	}

}
