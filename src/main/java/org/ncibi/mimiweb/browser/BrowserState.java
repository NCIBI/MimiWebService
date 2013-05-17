package org.ncibi.mimiweb.browser;

import java.util.ArrayList;
import java.util.Iterator;

import org.ncibi.mimiweb.browser.hibernate.data.GeneAttributeCount;

public class BrowserState {
	
	ArrayList<Constraint> constraints = null;
	int topCount = -1;
	int bottomCount = -1;
	int recordsToShow = 20;
	int genesToShow = 5;
	String searchConstraint = null;
	ArrayList<GeneAttributeCount> categoryList = null;
	
	public int count(){
		if (constraints == null) constraints = new ArrayList<Constraint>();
		return constraints.size();
	}
	
	public void addConstraint(Constraint c){
		if (constraints == null) constraints = new ArrayList<Constraint>();
		constraints.add(c);
	}
	
	public void addConstraint(String name, String value){
		addConstraint(new Constraint(name,value));
	}
	
	public void removeConstraint(int n){
		if ((constraints != null) && (n > -1) && (n < constraints.size()))
			constraints.remove(n);
	}
	
	public void clearConstraints() {
		if (constraints == null) constraints = new ArrayList<Constraint>();
		constraints.clear();
	}
	
	public ArrayList<Constraint> getConstraints(){
		if (constraints == null) constraints = new ArrayList<Constraint>();
		return constraints;
	}

	public Iterator<Constraint> iterator(){
		if (constraints == null) constraints = new ArrayList<Constraint>();
		return constraints.iterator();
	}

	/**
	 * @return the searchConstraint
	 */
	public String getSearchConstraint() {
		return searchConstraint;
	}

	/**
	 * @param searchConstraint the searchConstraint to set
	 */
	public void setSearchConstraint(String searchConstraint) {
		this.searchConstraint = searchConstraint;
	}
	
	public void clearSearchConstraint(){
		setSearchConstraint(null);
	}

	/**
	 * @return the topCount
	 */
	public int getTopCount() {
		return topCount;
	}

	/**
	 * @param topCount the topCount to set
	 */
	public void setTopCount(int topCount) {
		this.topCount = topCount;
	}

	/**
	 * @return the bottomCount
	 */
	public int getBottomCount() {
		return bottomCount;
	}

	/**
	 * @return the recordsToShow
	 */
	public int getRecordsToShow() {
		return recordsToShow;
	}

	/**
	 * @param recordsToShow the recordsToShow to set
	 */
	public void setRecordsToShow(int recordsToShow) {
		this.recordsToShow = recordsToShow;
	}

	/**
	 * @return the genesToShow
	 */
	public int getGenesToShow() {
		return genesToShow;
	}

	/**
	 * @param genesToShow the genesToShow to set
	 */
	public void setGenesToShow(int genesToShow) {
		this.genesToShow = genesToShow;
	}

	/**
	 * @param bottomCount the bottomCount to set
	 */
	public void setBottomCount(int bottomCount) {
		this.bottomCount = bottomCount;
	}

	/**
	 * @param constraints the constraints to set
	 */
	public void setConstraints(ArrayList<Constraint> constraints) {
		this.constraints = constraints;
	}

	/**
	 * @return the categoryList
	 */
	public ArrayList<GeneAttributeCount> getCategoryList() {
		return categoryList;
	}

	/**
	 * @param categoryList the categoryList to set
	 */
	public void setCategoryList(ArrayList<GeneAttributeCount> categoryList) {
		this.categoryList = categoryList;
	}
	
}
