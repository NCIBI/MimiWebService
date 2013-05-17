<%@
    page language = "java" import =    "org.ncibi.mimiweb.util.PsiDownload, 
                                        org.ncibi.mimiweb.data.ResultGeneMolecule,
                                        java.util.ArrayList,
                                        org.ncibi.mimiweb.hibernate.HibernateInterface"
%>

<%
    String geneid = (String) request.getParameter("geneid") ;

    HibernateInterface h = HibernateInterface.getInterface() ;
    ResultGeneMolecule g = h.getSingleGene(Integer.parseInt(geneid)) ;
    ArrayList<ResultGeneMolecule> gList = new ArrayList<ResultGeneMolecule>() ;
    gList.add(g) ;
    response.setHeader("Content-disposition","attachment;filename=\"mimigene.xml\"");
    out.print(PsiDownload.createXml(gList)) ;
%>

