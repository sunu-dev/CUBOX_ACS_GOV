package cubox.admin.main.service.vo;

import java.util.List;

public class UpperCodeVO {
	private String id;
	private String text;
	private String icon;
	private String href;
	private List<CodeVO> nodes;
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
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public List<CodeVO> getNodes() {
		return nodes;
	}
	public void setNodes(List<CodeVO> nodes) {
		this.nodes = nodes;
	}
	@Override
	public String toString() {
		return "CodeVO [id="+id+", text="+text+", icon="+icon+", href="+href+", nodes="+nodes+"]";
	}
}
