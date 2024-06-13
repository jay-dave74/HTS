<%@page import="com.liferay.asset.kernel.service.AssetCategoryLocalServiceUtil"%>
<%@page import="com.liferay.asset.kernel.model.AssetCategory"%>
<%@page import="java.util.List"%>
<%@ include file="/init.jsp" %>
<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<portlet:defineObjects />
<portlet:actionURL name="addTicket" var="addTicketActionURL"/>
<portlet:resourceURL id="/dynamicfetchSubCategories" var="DynamicsubCategoryResourceURL"/>

<script>
    if(!window.location.hash) {
        window.location = window.location + '#loaded';
        window.location.reload();
}
</script>

<h2>Generate Ticket</h2>
<aui:form action="<%= addTicketActionURL %>" name="ticketForm" method="POST" enctype="multipart/form-data">
    <aui:fieldset>
        <div class="row">
            <div class="col-md-6">
                <aui:input name="name" type="text" label="Name" required="true" cssClass="field-small" />
            </div>
            <div class="col-md-6">
                <aui:input name="subject" type="text" label="Subject" required="true" cssClass="field-small" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <aui:input name="description" type="textarea" label="Description" rows="3" required="true" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                <aui:select name="category" label="Category" required="true">
                    <aui:option label="Select" value="Select" />
                    <% 
                    List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(57801, -1, -1, null);
                    for (AssetCategory category : categories) {
                    %>
                    <aui:option label="<%= category.getName() %>" value="<%= category.getCategoryId() %>" />
                    <% } %>
                </aui:select>
            </div>
            <div class="col-md-6">
                <aui:select name="subCategory" label="Sub-Category" required="true">
                    <aui:option label="Select a category first" value="" />
                </aui:select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
               <aui:select name="department" label="Department" required="true">
                    <aui:option label="Select" value="Select" />
                    <% 
                    List<AssetCategory> categories = AssetCategoryLocalServiceUtil.getVocabularyRootCategories(59501, -1, -1, null);
                    for (AssetCategory category : categories) {
                    %>
                    <aui:option label="<%= category.getName() %>" value="<%= category.getName() %>" />
                    <% } %>
                </aui:select>
            </div>
            <div class="col-md-6">
                <aui:select name="priority" label="Priority" required="true">
                    <aui:option label="Low" value="Low" />
                    <aui:option label="Medium" value="Medium" />
                    <aui:option label="High" value="High" />
                </aui:select>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <aui:input name="attachFiles" type="file" label="Attach Files" />
            </div>
        </div>
    </aui:fieldset>

    <aui:button type="submit" value="Submit" />
</aui:form>

<style>
    .field-small input {
        width: 300px;
    }

    .row {
        margin-bottom: 15px;
    }

    .col-md-6 {
        display: inline-block;
        width: 48%;
        vertical-align: top;
    }

    .col-md-12 {
        width: 100%;
    }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const categorySelect = document.querySelector('[name="<portlet:namespace/>category"]');
    const subCategorySelect = document.querySelector('[name="<portlet:namespace/>subCategory"]');

    if (categorySelect && subCategorySelect) {
        categorySelect.addEventListener('change', function() {
            const selectedCategoryId = this.value;

            if (selectedCategoryId && selectedCategoryId !== 'Select') {
                Liferay.Util.fetch('<%= DynamicsubCategoryResourceURL %>', {
                    method: 'POST',
                    body: new URLSearchParams({
                    	<portlet:namespace/>categoryId: selectedCategoryId
                    }),
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    subCategorySelect.innerHTML = ''; 

                    if (data && data.length > 0) {
                        data.forEach(function(subCategory) {
                            var option = document.createElement('option');
                            option.value = subCategory.categoryId; 
                            option.label = subCategory.name;
                            option.textContent = subCategory.name;
                            subCategorySelect.appendChild(option);
                        });
                    } else {
                        var option = document.createElement('option');
                        option.value = '';
                        option.label = 'No subcategories available';
                        option.textContent = 'No subcategories available';
                        subCategorySelect.appendChild(option);
                    }
                })
                .catch(error => {
                    console.error('Error fetching subcategories:', error);
                });
            } else {
                subCategorySelect.innerHTML = ''; 
                var option = document.createElement('option');
                option.value = '';
                option.label = 'Select a category first';
                option.textContent = 'Select a category first';
                subCategorySelect.appendChild(option);
            }
        });
    } else {
        console.error('One or both select elements not found.');
    }
});

</script>
                                    