package org.ncibi.mimiweb.breadcrumbs;

public class Breadcrumb
{
	private String link ;
	private String description ;
	
	public Breadcrumb(String description, String link)
	{
		this.link = link ;
		this.description = description ;
	}
	
	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public String getLink()
	{
		return link;
	}

	public void setLink(String link)
	{
		this.link = link;
	}
}
