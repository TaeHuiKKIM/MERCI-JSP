<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.util.*, java.io.*, java.sql.*, my.dao.*, my.model.*, my.util.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    String realFolder = "";
    String saveFolder = "project/uploadfile";
    String encType = "UTF-8";
    int maxSize = 10 * 1024 * 1024;

    ServletContext context = getServletContext();
    realFolder = context.getRealPath(saveFolder);

    File dir = new File(realFolder);
    if (!dir.exists()) dir.mkdirs();

    try {
        MultipartRequest multi = null;
        multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

        int id = Integer.parseInt(multi.getParameter("id"));
        String title = multi.getParameter("title");
        String maker = multi.getParameter("maker");
        int price = Integer.parseInt(multi.getParameter("price"));
        int stock = Integer.parseInt(multi.getParameter("stock"));
        String sizes = multi.getParameter("sizes");
        String colors = multi.getParameter("colors");
        String clothType = multi.getParameter("clothType");
        String description = multi.getParameter("description");

        // 기존 파일명
        String oldImgBody = multi.getParameter("oldImgBody");
        String oldImgFront = multi.getParameter("oldImgFront");
        String oldImgBack = multi.getParameter("oldImgBack");
        String oldImgDetail = multi.getParameter("oldImgDetail");

        // 새 파일명
        String newImgBody = multi.getFilesystemName("imgBody");
        String newImgFront = multi.getFilesystemName("imgFront");
        String newImgBack = multi.getFilesystemName("imgBack");
        String newImgDetail = multi.getFilesystemName("imgDetail");

        // [DEV] 로컬 개발 환경에서 서버 리로드 시 이미지 삭제 방지를 위해 원본 폴더로 복사
        String srcFolder = "C:/webProgramming/ws/ShoppingAddict/WebContents/project/uploadfile";
        String[] uploadedFiles = {newImgBody, newImgFront, newImgBack, newImgDetail};
        
        for (String fName : uploadedFiles) {
            if (fName != null) {
                File savedFile = new File(realFolder, fName);
                File destFile = new File(srcFolder, fName);
                
                // 원본 폴더가 존재하는지 확인
                File destDir = new File(srcFolder);
                if(destDir.exists()) {
	                FileInputStream fis = null;
	                FileOutputStream fos = null;
	                try {
	                    fis = new FileInputStream(savedFile);
	                    fos = new FileOutputStream(destFile);
	                    byte[] buf = new byte[1024];
	                    int len;
	                    while ((len = fis.read(buf)) > 0) {
	                        fos.write(buf, 0, len);
	                    }
	                } catch (IOException e) {
	                    System.out.println("Source copy failed: " + e.getMessage());
	                } finally {
	                    if (fis != null) try { fis.close(); } catch(Exception e) {}
	                    if (fos != null) try { fos.close(); } catch(Exception e) {}
	                }
                }
            }
        }

        // 변경 없으면 기존값 유지
        String imgBody = (newImgBody != null) ? newImgBody : oldImgBody;
        String imgFront = (newImgFront != null) ? newImgFront : oldImgFront;
        String imgBack = (newImgBack != null) ? newImgBack : oldImgBack;
        String imgDetail = (newImgDetail != null) ? newImgDetail : oldImgDetail;

        Cloth cloth = new Cloth();
        cloth.setId(id);
        cloth.setTitle(title);
        cloth.setMaker(maker);
        cloth.setPrice(price);
        cloth.setStock(stock);
        cloth.setSizes(sizes);
        cloth.setColors(colors);
        cloth.setClothType(clothType);
        cloth.setDescription(description);
        
        cloth.setImgBody(imgBody);
        cloth.setImgFront(imgFront);
        cloth.setImgBack(imgBack);
        cloth.setImgDetail(imgDetail);

        Connection conn = ConnectionProvider.getConnection();
        ClothDao dao = new ClothDao();
        dao.update(conn, cloth);
        JdbcUtil.close(conn);

        out.println("<script>alert('수정되었습니다.'); location.href='manageproduct.jsp';</script>");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('상품 수정 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
