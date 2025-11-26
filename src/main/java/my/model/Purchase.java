package my.model;

import java.util.Date;

public class Purchase {
	private int pid;
	private String customer;
	private int clothId;
	private int amount;
	private int total;
	private Date pdate;
	
	public Purchase() {}
	
	public Purchase(String customer, int clothId, int amount, int total, Date pdate) {
		super();
		this.customer = customer;
		this.clothId = clothId;
		this.amount = amount;
		this.total = total;
		this.pdate = pdate;
	}

	public int getPid() {
		return pid;
	}

	public void setPid(int pid) {
		this.pid = pid;
	}

	public String getCustomer() {
		return customer;
	}

	public void setCustomer(String customer) {
		this.customer = customer;
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

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public Date getPdate() {
		return pdate;
	}

	public void setPdate(Date pdate) {
		this.pdate = pdate;
	} 
	
	
	

}
