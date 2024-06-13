<%@page import="java.util.List"%>
<%@ page import="com.liferay.portal.kernel.util.PortalUtil" %>
<%@ page import="com.liferay.portal.kernel.log.Log" %>
<%@ page import="com.liferay.portal.kernel.log.LogFactoryUtil" %>
<%@ page import="com.liferay.portal.kernel.service.RoleLocalServiceUtil" %>
<%@ page import="com.liferay.portal.kernel.service.UserLocalServiceUtil" %>
<%@ page import="com.liferay.portal.kernel.exception.PortalException" %>
<%@ page import="com.liferay.portal.kernel.model.Role" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ include file="/init.jsp" %>

<portlet:defineObjects />

<script>
    if(!window.location.hash) {
        window.location = window.location + '#loaded';
        window.location.reload();
}
</script>

<%
    List<Role> roles = RoleLocalServiceUtil.getRoles(themeDisplay.getCompanyId());
%>
<%
    com.liferay.portal.kernel.model.User user1 = themeDisplay.getUser();

    boolean isAdmin = false;
    try {
        Role adminRole = RoleLocalServiceUtil.getRole(themeDisplay.getCompanyId(), "Administrator");
        isAdmin = user1.getRoles().contains(adminRole);
    } catch (PortalException e) {
        Log log = LogFactoryUtil.getLog("AdminCheck");
        log.error("Error checking admin role: " + e.getMessage());
    }

    if (!isAdmin) {
        response.sendRedirect(themeDisplay.getURLSignIn());
        return;
    }
%>

<h2>Add New User</h2>

<aui:form name="addUserForm" method="post" id="addUserForm" onsubmit="return false;">
    <aui:fieldset>
        <aui:input name="screenName" label="Screen Name" type="text" required="true" />
        <aui:input name="email" label="Email Address" type="text" required="true" />
        <aui:input name="firstName" label="First Name" type="text" required="true" />
        <aui:input name="lastName" label="Last Name" type="text" required="true" />
        <aui:input name="password1" label="Password" type="password" required="true" />
        <aui:input name="password2" label="Confirm Password" type="password" required="true" />
        
         <aui:select name="role" label="Role" required="true">
            <%
                for (Role role : roles) {
            %>
                <aui:option label="<%= role.getTitle(locale) %>" value="<%= role.getName() %>" />
            <%
                }
            %>
        </aui:select>
    </aui:fieldset>

    <aui:button type="button" value="Register" onClick="submitForm();" style="background-color: blue; color: white;" />
</aui:form>

<script>
document.addEventListener('DOMContentLoaded', function () {
    function submitForm() {
        console.log("submitForm function called");

        var userData = {
            "screenName": document.getElementById('<portlet:namespace/>screenName').value,
            "email": document.getElementById('<portlet:namespace/>email').value,
            "firstName": document.getElementById('<portlet:namespace/>firstName').value,
            "lastName": document.getElementById('<portlet:namespace/>lastName').value,
            "password1": document.getElementById('<portlet:namespace/>password1').value,
            "password2": document.getElementById('<portlet:namespace/>password2').value,
            "role": document.getElementById('<portlet:namespace/>role').value
        };

        console.log(userData);

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'http://localhost:8080/o/AddUserRestBuilder/v1.0/add-user', true);
        xhr.setRequestHeader('Accept', 'application/json');
        xhr.setRequestHeader('Content-Type', 'application/json');
        var username = 'jay.d@tridhyatech.com';
        var password = 'jaydave';
        var basicAuth = 'Basic ' + btoa(username + ':' + password);
        xhr.setRequestHeader('Authorization', basicAuth);

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                console.log("Response received: ", xhr.status, xhr.responseText);
                if (xhr.status === 200) {
                    alert('User registered successfully!');
                } else {
                    alert('Error registering user: ' + xhr.responseText);
                }
            }
        };

        xhr.send(JSON.stringify(userData));
            
        console.log("Request sent with data: ", JSON.stringify(userData));
       // location.reload();   
    }

    window.submitForm = submitForm;
});
</script>
