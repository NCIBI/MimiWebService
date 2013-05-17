var inSetHidden = false ;

function getElementsByClass(searchClass,node,tag)
{
    var classElements = new Array();

    if ( node == null )
    {
        node = document;
    }

    if ( tag == null )
    {
        tag = '*';
    }

    var els = node.getElementsByTagName(tag);
    var elsLen = els.length;
    var pattern = new RegExp("(^|\\\\s)"+searchClass+"(\\\\s|$)");

    for (i = 0, j = 0; i < elsLen; i++)
    {
        if ( pattern.test(els[i].className) )
        {
            classElements[j] = els[i];
            j++;
        }
    }

    return classElements;
}

function toggleBox(divid)
{
    toggleBoxNoSave(divid) ;
    saveHiddenElements() ;
}

function toggleBoxNoSave(divid)
{
    var obj = document.getElementById(divid);

    if (obj != null)
    {
        if (obj.style.display == "none")
        {
            obj.style.visibility = "visible";
            obj.style.display = "block";
        }
        else
        {
            obj.style.visibility = "hidden";
            obj.style.display = "none";
        }
    }
}

function gotoAnchor(where, id)
{
    toggleBox(id) ;
    window.location.hash = where ;
}

function ncibi_callback(data)
{
    //console.log("ncibi_callback() = " + inSetHidden) ;
    dwr.util.setValue("dt-replace-here", data, { escapeHtml:false });
    var xx = document.getElementById("executeme") ;
    //alert(xx) ;
    //alert(xx.text) ;
    if (xx != null)
    {
        eval(xx.text) ;
    }
    var e = document.getElementById("savestate") ;
    var he = document.getElementById("savestate2") ;
    if (he != null)
    {
        if (inSetHidden == false)
        {
            he.value = data ;
            //console.log('set savestate2 = ' + he.value) ;
        }
    }
    if (e != null)
    {
        if (e.value != "no")
        {
            //console.log("calling setHiddenElements from ncibi_callback") ;
            setHiddenElements(e.value, false) ;
        }
    }
}

function setHiddenElements(celementstr, sethtml)
{
    //console.log("setHiddenElements = " + inSetHidden) ;
    if (inSetHidden == false)
    {
        inSetHidden = true ;
        setHiddenElementsReal(celementstr, sethtml) ;
    }
}

function setHiddenElementsReal(celementstr, sethtml)
{
    //console.log("setHiddenElementsReal") ;
    celements = getElementsByClass("hiddenelement", null, null) ;
    if (celements.length > 0)
    {

        if (sethtml)
        {
            var he = document.getElementById("savestate2") ;
            if (he != null && he.value != "no")
            {
                //console.log(he.value) ;
                dwr.util.setValue("dt-replace-here", he.value, { escapeHtml:false });
            }
        }

        setHiddenElements2(celementstr, celements) ;
    }
    else
    {
        setTimeout('setHiddenElementsReal("'+celementstr+'",'+sethtml+')', 400) ;
    }
}

function setHiddenElements2(celementsstr, celements2)
{
    //console.log("setHiddenElements2") ;
    var celements = celementsstr.split(",") ;
    if (celements.length > 0)
    {
        for ( i = 0 ; i < celements.length ; i++ )
        {
            var pieces = celements[i].split(":") ;
            if (pieces[1] != celements2[i].style.display)
            {
                toggleBoxNoSave(pieces[0]) ;
            }
        }
    }
    inSetHidden = false ;
}

function page_onload()
{
    //console.log("page_onload") ;
    var e = document.getElementById("savestate") ;
    if (e != null)
    {
        if (e.value != "no")
        {
            //console.log("calling setHiddenElements from page_onload") ;
            setHiddenElements(e.value, true) ;
        }
    }
}

function saveHiddenElements()
{
    celements = getElementsByClass("hiddenelement", null, null) ;
    var e = document.getElementById("savestate") ;
    var str = "" ;
    for (i = 0 ; i < celements.length ; i++)
    {
        if (i == 0)
        {
            str = celements[i].id + ':' + celements[i].style.display ;
        }
        else
        {
            str += "," + celements[i].id + ':' + celements[i].style.display ;
        }
    }
    e.value = str ;
}

function page_onunload()
{
    /* Not used because of IE/Firefox differences */
    //saveHiddenElements() ;
}
