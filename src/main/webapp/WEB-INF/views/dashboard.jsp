<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />
<!DOCTYPE html>
<html>
<head>
<title>面板</title>

    <style>
        #xxx {width:100%; height: 400px; }
    </style>
</head>
<body>

<div id="xxx" tabindex="0"></div>
<div id='panel'></div>
<script type="text/javascript" src="http://webapi.amap.com/maps?v=1.3&key=106a6436d7e149826b23dea6d74d2937"></script>
<script type="text/javascript">
    var map = new AMap.Map('xxx',{
        resizeEnable: true,
//        zoom: 10,
//        center: [116.480983, 40.0958]
    });
    var marker = new AMap.Marker({
//        position: [116.480983, 39.989628],
        map:map
    });
    var infowindow = new AMap.InfoWindow({
        content: '这里正发生火灾',
        offset: new AMap.Pixel(0, -30),
        size:new AMap.Size(230,0)
    })
    infowindow.open(map,marker.getPosition());
    var clickHandle = AMap.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker.getPosition())
    })
</script>
</body>
</html>