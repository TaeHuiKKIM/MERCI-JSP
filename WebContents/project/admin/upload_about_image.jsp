<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>

<%
    String realPath = application.getRealPath("/project/images");
    int maxSize = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";

    try {
        MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, encoding, new DefaultFileRenamePolicy());

        Enumeration files = multi.getFileNames();
        String file_name = "";
        
        while(files.hasMoreElements()){
            String name = (String)files.nextElement();
            file_name = multi.getFilesystemName(name);
        }

        if (file_name != null) {
            File oldFile = new File(realPath, file_name);
            File newFile = new File(realPath, "about_custom.jpg");

            if (newFile.exists()) {
                newFile.delete();
            }
            oldFile.renameTo(newFile);
            
            response.sendRedirect("manageabout.jsp");
        } else {
            // 파일 업로드 실패 처리
            out.println("<script>");
            out.println("alert('파일 업로드에 실패했습니다.');");
            out.println("history.back();");
            out.println("</script>");
        }

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('파일 업로드 중 오류가 발생했습니다: " + e.getMessage() + "');");
        out.println("history.back();");
        out.println("</script>");
    }
%>
