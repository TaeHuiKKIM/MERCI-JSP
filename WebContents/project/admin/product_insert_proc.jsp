<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="java.util.*, java.io.*, java.sql.*, my.dao.*, my.model.*, my.util.*"%>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 업로드 경로 설정
    String realFolder = "";
    String saveFolder = "project/uploadfile";
    String encType = "UTF-8";
    int maxSize = 10 * 1024 * 1024; // 10MB

    ServletContext context = getServletContext();
    realFolder = context.getRealPath(saveFolder);

    // 폴더 없으면 생성 (옵션)
    File dir = new File(realFolder);
    if (!dir.exists()) {
        dir.mkdirs();
    }

    try {
        MultipartRequest multi = null;
        multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

        // 2. 파라미터 수신
        String title = multi.getParameter("title");
        String maker = multi.getParameter("maker");
        int price = Integer.parseInt(multi.getParameter("price"));
        int stock = Integer.parseInt(multi.getParameter("stock"));
        String sizes = multi.getParameter("sizes");
        String colors = multi.getParameter("colors");
        String clothType = multi.getParameter("clothType");
        String description = multi.getParameter("description");

        // 3. 파일명 수신
        String imgBody = multi.getFilesystemName("imgBody");
        String imgFront = multi.getFilesystemName("imgFront");
        String imgBack = multi.getFilesystemName("imgBack");
        String imgDetail = multi.getFilesystemName("imgDetail");

        // 파일이 업로드되지 않았을 경우 처리 (null 방지 혹은 기본값)
        // 여기서는 업로드 안하면 null로 들어감. 보여줄 때 처리하거나 필수로 강제.
        // imgBody는 form에서 required였음.
        if (imgFront == null) imgFront = imgBody; // 없으면 메인 사진으로 대체 (선택사항)
        if (imgBack == null) imgBack = imgBody;
        if (imgDetail == null) imgDetail = imgBody;

        // 4. 객체 생성
        Cloth cloth = new Cloth();
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
        
        cloth.setFreq(0);
        cloth.setOpenDate(new java.util.Date());

        // 5. DB 저장
        Connection conn = ConnectionProvider.getConnection();
        ClothDao dao = new ClothDao();
        dao.insert(conn, cloth);
        JdbcUtil.close(conn);

        response.sendRedirect("manageproduct.jsp");

    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('상품 등록 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>
