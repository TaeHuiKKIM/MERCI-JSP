package my.model;

public class Cart {
	private int clothId;
	private int amount;
	public Cart(int clothId, int amount) {
		super();
		this.clothId = clothId;
		this.amount = amount;
	}
	public int getClothId() {
		return clothId;
	}
	public void setClothId(int clothId) {
		this.clothId = clothId;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}	
}

