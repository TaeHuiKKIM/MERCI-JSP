package my.model;

import java.util.Date;

public class User {
	private String userId;
	private String password;
	private String name;
	private Date registerTime;
	private String findQ; // Password recovery question
	private String findA; // Password recovery answer
	
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Date getRegisterTime() {
		return registerTime;
	}
	public void setRegisterTime(Date registerTime) {
		this.registerTime = registerTime;
	}
	public String getFindQ() {
		return findQ;
	}
	public void setFindQ(String findQ) {
		this.findQ = findQ;
	}
	public String getFindA() {
		return findA;
	}
	public void setFindA(String findA) {
		this.findA = findA;
	}
}
