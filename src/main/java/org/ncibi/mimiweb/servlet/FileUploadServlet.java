package org.ncibi.mimiweb.servlet;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.util.Calendar ;

public class FileUploadServlet extends HttpServlet
{
    private static final long serialVersionUID = -3449840032744254096L;
    private static final String DEFAULT_ERROR_RESPONSE = "{error: 'File upload failed.'}";

    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        FileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> items = null;
        String json_response = DEFAULT_ERROR_RESPONSE;
        
//        String tmpdir = System.getProperty("java.io.tmpdir") ;

        try
        {
            items = upload.parseRequest(request);
        }
        catch (FileUploadException e)
        {
            e.printStackTrace();
        }

        for (FileItem item : items)
        {
            json_response = processFile(item);
        }

        response.setContentType("text/plain");
        response.getWriter().write(json_response);

    }

    private String processFile(FileItem item)
    {
        Calendar today = Calendar.getInstance();
        FileInputStream fis = null;
        BufferedInputStream bis = null;
        BufferedReader input;
        String status = DEFAULT_ERROR_RESPONSE;

        try
        {
        	File uploadedFile = File.createTempFile("XXX" + today.getTimeInMillis(), ".tmp");
            item.write(uploadedFile);
            fis = new FileInputStream(uploadedFile);

            // Here BufferedInputStream is added for fast reading.
            bis = new BufferedInputStream(fis);
            input = new BufferedReader(new InputStreamReader(bis));
            String geneid;
            String geneidlist = "";

            while ((geneid = input.readLine()) != null)
            {
                geneidlist += geneid + " ";
            }

            // dispose all the resources after using them.
            fis.close();
            bis.close();
            input.close();

            status = "{success: '" + geneidlist + "'}";
            uploadedFile.delete() ;

        }
        catch (FileNotFoundException e)
        {
            e.printStackTrace();
            status = "{error: 'FileNotFoundException: " + e.getMessage() + "'}";
        }
        catch (IOException e)
        {
            e.printStackTrace();
            status = "{error: 'IOException: " + e.getMessage() + "'}";
        }
        catch (Exception e)
        {
            e.printStackTrace();
            status = "{error: 'Exception: " + e.getMessage() + "'}";
        }
        return status;
    }
}
