<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request"/>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>接口文档说明</title>
  <link href='${ctx}/resources/api-docs/css/reset.css' media='screen' rel='stylesheet' type='text/css'/>
  <link href='${ctx}/resources/api-docs/css/screen.css' media='screen' rel='stylesheet' type='text/css'/>
  <link href='${ctx}/resources/api-docs/css/reset.css' media='print' rel='stylesheet' type='text/css'/>
  <link href='${ctx}/resources/api-docs/css/screen.css' media='print' rel='stylesheet' type='text/css'/>
  
  <script src="${ctx}/resources/api-docs/lib/shred.bundle.js" type="text/javascript"></script>
  <script src='${ctx}/resources/api-docs/lib/jquery-1.8.0.min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/jquery.slideto.min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/jquery.wiggle.min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/jquery.ba-bbq.min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/handlebars-1.0.0.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/underscore-min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/backbone-min.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/swagger.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/swagger-client.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/swagger-ui.js' type='text/javascript'></script>
  <script src='${ctx}/resources/api-docs/lib/highlight.7.3.pack.js' type='text/javascript'></script>

  <!-- enabling this will enable oauth2 implicit scope support -->
  <script src='${ctx}/resources/api-docs/lib/swagger-oauth.js' type='text/javascript'></script>
  <script type="text/javascript">
    $(function () {
      var url = window.location.search.match(/url=([^&]+)/);
      if (url && url.length > 1) {
        url = url[1];
      } else {
        url = "${ctx}/api-docs?group=${group}";
      }
      window.swaggerUi = new SwaggerUi({
        url: url,
        dom_id: "swagger-ui-container",
        supportedSubmitMethods: ['get', 'post', 'put', 'delete'],
        onComplete: function(swaggerApi, swaggerUi){
          log("Loaded SwaggerUI");
          if(typeof initOAuth == "function") {
            /*
            initOAuth({
              clientId: "your-client-id",
              realm: "your-realms",
              appName: "your-app-name"
            });
            */
          }
          $('pre code').each(function(i, e) {
            hljs.highlightBlock(e)
          });
        },
        onFailure: function(data) {
          log("Unable to Load SwaggerUI");
        },
        docExpansion: "none",
        sorter : "alpha"
      });

      function addApiKeyAuthorization() {
        var key = $('#input_apiKey')[0].value;
        log("key: " + key);
        if(key && key.trim() != "") {
            log("added key " + key);
            window.authorizations.add("api_key", new ApiKeyAuthorization("api_key", key, "query"));
        }
      }

      $('#input_apiKey').change(function() {
        addApiKeyAuthorization();
      });

      // if you have an apiKey you would like to pre-populate on the page for demonstration purposes...
      /*
        var apiKey = "myApiKeyXXXX123456789";
        $('#input_apiKey').val(apiKey);
        addApiKeyAuthorization();
      */

      window.swaggerUi.load();
  });
  </script>
  
  <style type="text/css">
  .swagger-ui-wrap .info{
  	display : none;
  }
  </style>
</head>

<body class="swagger-section">
<div id='header'>
  <div class="swagger-ui-wrap">
    <a id="logo" href="javascript:void(0);">接口文档说明</a>
    <form id='api_selector'>
      <div class='input'><input placeholder="http://example.com/api" id="input_baseUrl" name="baseUrl" type="text"/></div>
      <div class='input'><input placeholder="api_key" id="input_apiKey" name="apiKey" type="text"/></div>
      <div class='input'><a id="explore" href="#">流览</a></div>
    </form>
  </div>
</div>

<div id="message-bar" class="swagger-ui-wrap">&nbsp;</div>
<div id="swagger-ui-container" class="swagger-ui-wrap"></div>
</body>
</html>
