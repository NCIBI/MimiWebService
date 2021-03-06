package org.ncibi.mimiweb.browser.hibernate.generated;

// Generated Jul 13, 2008 11:16:09 PM by Hibernate Tools 3.2.0.CR1

/**
 * GeneAttributeId generated by hbm2java
 */
public class GeneAttributeId implements java.io.Serializable {

	private Integer geneid;
	private String attrType;
	private String attrValue;

	public GeneAttributeId() {
	}

	public GeneAttributeId(Integer geneid, String attrType, String attrValue) {
		this.geneid = geneid;
		this.attrType = attrType;
		this.attrValue = attrValue;
	}

	public Integer getGeneid() {
		return this.geneid;
	}

	public void setGeneid(Integer geneid) {
		this.geneid = geneid;
	}

	public String getAttrType() {
		return this.attrType;
	}

	public void setAttrType(String attrType) {
		this.attrType = attrType;
	}

	public String getAttrValue() {
		return this.attrValue;
	}

	public void setAttrValue(String attrValue) {
		this.attrValue = attrValue;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof GeneAttributeId))
			return false;
		GeneAttributeId castOther = (GeneAttributeId) other;

		return ((this.getGeneid() == castOther.getGeneid()) || (this
				.getGeneid() != null
				&& castOther.getGeneid() != null && this.getGeneid().equals(
				castOther.getGeneid())))
				&& ((this.getAttrType() == castOther.getAttrType()) || (this
						.getAttrType() != null
						&& castOther.getAttrType() != null && this
						.getAttrType().equals(castOther.getAttrType())))
				&& ((this.getAttrValue() == castOther.getAttrValue()) || (this
						.getAttrValue() != null
						&& castOther.getAttrValue() != null && this
						.getAttrValue().equals(castOther.getAttrValue())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getGeneid() == null ? 0 : this.getGeneid().hashCode());
		result = 37 * result
				+ (getAttrType() == null ? 0 : this.getAttrType().hashCode());
		result = 37 * result
				+ (getAttrValue() == null ? 0 : this.getAttrValue().hashCode());
		return result;
	}

}
