<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.FileRenamePolicy" %>

<%
    String realPath = application.getRealPath("/project/images");
    int maxSize = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";

    try {
        // Implement a custom FileRenamePolicy to avoid issues with DefaultFileRenamePolicy
        FileRenamePolicy policy = new FileRenamePolicy() {
            public File rename(File f) {
                // Create a unique file name by appending the current timestamp,
                // then handle the final renaming to 'about_custom.jpg' in the code below.
                String name = f.getName();
                String ext = "";
                int dot = name.lastIndexOf(".");
                if (dot != -1) {
                    ext = name.substring(dot);
                    name = name.substring(0, dot);
                }
                String newName = name + "_" + System.currentTimeMillis() + ext;
                return new File(f.getParent(), newName);
            }
        };

        MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, encoding, policy);

        Enumeration files = multi.getFileNames();
        String filesystemFileName = null;

        if (files.hasMoreElements()) {
            String name = (String) files.nextElement();
            filesystemFileName = multi.getFilesystemName(name);
        }

        if (filesystemFileName != null) {
            File uploadedFile = new File(realPath, filesystemFileName);
            File newFile = new File(realPath, "about_custom.jpg");

            if (newFile.exists()) {
                if (!newFile.delete()) {
                    throw new IOException("Cannot delete existing file: " + newFile.getName());
                }
            }
            
            if (uploadedFile.renameTo(newFile)) {
                // Success
                response.sendRedirect("manageabout.jsp");
            } else {
                // If rename fails, try to copy and delete as a fallback
                try {
                    java.nio.file.Files.copy(uploadedFile.toPath(), newFile.toPath());
                    uploadedFile.delete();
                    response.sendRedirect("manageabout.jsp");
                } catch (Exception copyEx) {
                    throw new IOException("Failed to rename or copy the file.", copyEx);
                }
            }
        } else {
            // No file was uploaded
            out.println("<script>alert('파일이 업로드되지 않았습니다.'); history.back();</script>");
        }

    } catch (Exception e) {
        response.setContentType("text/html; charset=UTF-8");
        out.println("<h3>An Error Occurred:</h3><pre>");
        e.printStackTrace(new java.io.PrintWriter(out));
        out.println("</pre>");
    }
%>
