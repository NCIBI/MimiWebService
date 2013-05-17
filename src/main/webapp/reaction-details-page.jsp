<%@ taglib uri="http://displaytag.sf.net" prefix="display" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="inc/header2.jsp" %>
<%@ page import="java.io.*,
                java.util.ArrayList,
                org.ncibi.mimiweb.data.hibernate.*, 
                org.ncibi.mimiweb.hibernate.*,
                org.ncibi.mimiweb.util.FlotUtil,
                org.ncibi.mimiweb.data.*" %>
<%
    ArrayList<Compound> compounds = (ArrayList<Compound>) session.getAttribute("compounds") ;
    request.setAttribute("compounds", compounds) ;
%>
<br />
<h3><img src="images/Compound01.png" alt="Compunds"/>Compounds in reaction (<%=compounds.size()%> compounds found) - <a href="javascript:toggleBox('compound-sh')">show/hide</a></h3>
    <hr/>
<div class="hiddenelement" id="compound-sh" style="visibility: hidden; display:none;">


    <display:table name="compounds" class="displaytag" id="compoundstable" requestURI="replaceURI">
        <display:setProperty name="basic.msg.empty_list" value="No compounds for this gene were found in the database." />
        <display:setProperty name="paging.banner.item_name" value="compound" />
        <display:setProperty name="paging.banner.items_name" value="compounds" />
        <display:column property="cid" sortable="true" title="Id" 
            href="compound-details-page-front.jsp" paramId="cid" paramProperty="cid" />
        <display:column property="name" sortable="true" title="Name"/>
        <display:column property="mf" title="MF"/>
        <display:column property="molecularWeight" sortable="true" title="Mol. Weight"/>
        <display:column property="casnum" sortable="true" title="CASNUM"/>
        <display:column property="smile" title="Smile"/>
    </display:table>
</div>
  </div>
  </div>
