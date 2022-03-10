package cubox.admin.main.service.vo;

public class CodeVO {
	private String id;
	private String text;
	private String icon;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getIcon() {
		return icon;
	}
	public void setIcon(String icon) {
		this.icon = icon;
	}
	@Override
	public String toString() {
		return "CodeVO [id="+id+", text="+text+", icon="+icon+"]";
	}
}
