<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div id="mimi-nav">
	<script type="text/javascript">
		function highlightTab(name) {
			var element = document.getElementById(name);
			element.id="current";
		}
	</script>
	<ul>
	<li><a href="main-page.jsp" id="main-page">Free Text Search</a></li>
	<li><a href="upload-page.jsp" id="gene-list-page">List Search</a></li>
	<li><a href="interaction-query-page.jsp" id="interaction-page">Query Interactions</a></li>
	<li><a href="AboutPage.html" id="about-page">About MiMI</a></li>
	<li><a href="HelpPage.html" id="hepl-page">Help</a></li>
	</ul>
	<script type="text/javascript">
		highlightTab(pageTab);
	</script>
</div>
<!-- End mimi-nav div -->
