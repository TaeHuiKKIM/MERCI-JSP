<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.sql.*, my.dao.*, my.model.*, my.util.*" %>
<%@ page import="java.io.File" %>

<%    String savePath = application.getRealPath("/project/uploadfile");
    String localSourcePath = "C:\\webProgramming\\ws\\ShoppingAddict\\WebContents\\project\\uploadfile"; 
    
    File dir = new File(savePath);
    if(!dir.exists()) dir.mkdirs();
    
    int sizeLimit = 10 * 1024 * 1024; 
    String encoding = "UTF-8";
    
    Connection conn = null;

    try {
        MultipartRequest multi = new MultipartRequest(
                request,
                savePath,
                sizeLimit,
                encoding,
                new DefaultFileRenamePolicy()
        );
        
        int id = Integer.parseInt(multi.getParameter("id"));
        String title = multi.getParameter("title");
        String maker = multi.getParameter("maker");
        int price = Integer.parseInt(multi.getParameter("price"));
        String clothType = multi.getParameter("clothType");
        String existingPoster = multi.getParameter("existingPoster");
        
        String newFileName = multi.getFilesystemName("newPoster");
        String finalPoster = (newFileName != null) ? newFileName : existingPoster;
        
        if(newFileName != null) {
            try {
                File srcFile = new File(savePath, newFileName);
                File destFile = new File(localSourcePath, newFileName);
                java.nio.file.Files.copy(srcFile.toPath(), destFile.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            } catch(Exception e) {}
        }
        
        Cloth cloth = new Cloth();
        cloth.setId(id);
        cloth.setTitle(title);
        cloth.setMaker(maker);
        cloth.setPrice(price);
        cloth.setClothType(clothType);
        cloth.setPoster(finalPoster);
        
        conn = ConnectionProvider.getConnection();
        // conn.setAutoCommit(false);
        
        ClothDao dao = new ClothDao();
        dao.update(conn, cloth); // 이제 conn을 닫지 않고 예외를 던짐
        
        // conn.commit();
        
        out.println("<script>alert('수정이 완료되었습니다.'); location.href='manageproduct.jsp';</script>");
        
    } catch(Exception e) {
        // if(conn != null) try{ conn.rollback(); } catch(Exception ex){}
        e.printStackTrace();
        String msg = e.getMessage().replace("'", "\\'").replace("\n", " ");
        out.println("<script>alert('수정 실패: " + msg + "'); history.back();</script>");
    } finally {
        JdbcUtil.close(conn); // 필수
    }
%>