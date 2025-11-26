package my.model;

public class DeliveryAddress {

	private int addrId;
	private String userId;
	private String addrName; // 배송지 별칭 (집, 회사 등)
	private String recipientName; // 수령인
	private String phone;
	private String addrRoad;
	private String addrDetail;

	public DeliveryAddress() {}

	public DeliveryAddress(int addrId, String userId, String addrName, String recipientName, String phone,
			String addrRoad, String addrDetail) {
		super();
		this.addrId = addrId;
		this.userId = userId;
		this.addrName = addrName;
		this.recipientName = recipientName;
		this.phone = phone;
		this.addrRoad = addrRoad;
		this.addrDetail = addrDetail;
	}

	public int getAddrId() {
		return addrId;
	}

	public void setAddrId(int addrId) {
		this.addrId = addrId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAddrName() {
		return addrName;
	}

	public void setAddrName(String addrName) {
		this.addrName = addrName;
	}

	public String getRecipientName() {
		return recipientName;
	}

	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddrRoad() {
		return addrRoad;
	}

	public void setAddrRoad(String addrRoad) {
		this.addrRoad = addrRoad;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

}
