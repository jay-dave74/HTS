package CreateNewUserRestbuilder.internal.jaxrs.application;

import javax.annotation.Generated;

import javax.ws.rs.core.Application;

import org.osgi.service.component.annotations.Component;

/**
 * @author Jay
 * @generated
 */
@Component(
	property = {
		"liferay.jackson=false",
		"osgi.jaxrs.application.base=/CreateNewUserRestbuilder",
		"osgi.jaxrs.extension.select=(osgi.jaxrs.name=Liferay.Vulcan)",
		"osgi.jaxrs.name=CreateNewUserRestbuilder"
	},
	service = Application.class
)
@Generated("")
public class CreateNewUserRestbuilderApplication extends Application {
}