<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.util.*" %>

<% 
    // [설정] PNG 파일만 허용 및 about_custom.png로 저장

    // 1. 경로 설정
    String realPath = application.getRealPath("/project/images");
    String sourcePath = "C:\\webProgramming\\ws\\ShoppingAddict\\WebContents\\project\\images";
    
    if (realPath == null) realPath = sourcePath;
    
    File realDir = new File(realPath);
    if (!realDir.exists()) realDir.mkdirs();
    
    File sourceDir = new File(sourcePath);
    if (!sourceDir.exists()) sourceDir.mkdirs();

    // 2. 업로드 설정
    int sizeLimit = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";
    
    try {
        MultipartRequest multi = new MultipartRequest(
                request, 
                realPath, 
                sizeLimit, 
                encoding, 
                new DefaultFileRenamePolicy()
        );
        
        String fileName = multi.getFilesystemName("aboutImage");
        
        if (fileName != null) {
            File uploadedFile = new File(realPath, fileName);
            
            // [유효성 검사] PNG 확장자 체크
            if (!fileName.toLowerCase().endsWith(".png")) {
                // PNG가 아니면 삭제 후 경고
                uploadedFile.delete();
                out.println("<script>alert('오직 PNG 파일만 업로드 가능합니다. (Only PNG files allowed)'); history.back();</script>");
            } else {
                // [성공 처리] about_custom.png 로 저장
                String targetName = "about_custom.png";
                
                File targetRealFile = new File(realPath, targetName);
                File targetSourceFile = new File(sourcePath, targetName);
                
                // 덮어쓰기
                Files.copy(uploadedFile.toPath(), targetRealFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                Files.copy(targetRealFile.toPath(), targetSourceFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                
                // 원본 이름 정리
                if (!fileName.equals(targetName)) {
                    uploadedFile.delete();
                }
                
                response.sendRedirect("manageabout.jsp");
            }
        } else {
             out.println("<script>alert('파일을 선택해주세요.'); history.back();</script>");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('업로드 에러: " + e.getMessage() + "'); history.back();</script>");
    }
%>