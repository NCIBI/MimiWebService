package org.ncibi.mimiweb.browser.hibernate.generated;

// Generated Jul 13, 2008 11:16:09 PM by Hibernate Tools 3.2.0.CR1

/**
 * GeneGeneInteractionAttributeId generated by hbm2java
 */
public class GeneGeneInteractionAttributeId implements java.io.Serializable {

	private Integer ggIntId;
	private String attrType;
	private String attrValue;

	public GeneGeneInteractionAttributeId() {
	}

	public GeneGeneInteractionAttributeId(Integer ggIntId, String attrType,
			String attrValue) {
		this.ggIntId = ggIntId;
		this.attrType = attrType;
		this.attrValue = attrValue;
	}

	public Integer getGgIntId() {
		return this.ggIntId;
	}

	public void setGgIntId(Integer ggIntId) {
		this.ggIntId = ggIntId;
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
		if (!(other instanceof GeneGeneInteractionAttributeId))
			return false;
		GeneGeneInteractionAttributeId castOther = (GeneGeneInteractionAttributeId) other;

		return ((this.getGgIntId() == castOther.getGgIntId()) || (this
				.getGgIntId() != null
				&& castOther.getGgIntId() != null && this.getGgIntId().equals(
				castOther.getGgIntId())))
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
				+ (getGgIntId() == null ? 0 : this.getGgIntId().hashCode());
		result = 37 * result
				+ (getAttrType() == null ? 0 : this.getAttrType().hashCode());
		result = 37 * result
				+ (getAttrValue() == null ? 0 : this.getAttrValue().hashCode());
		return result;
	}

}
