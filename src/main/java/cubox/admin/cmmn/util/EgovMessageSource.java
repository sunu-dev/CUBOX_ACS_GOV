package cubox.admin.cmmn.util;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;

public class EgovMessageSource extends ReloadableResourceBundleMessageSource implements MessageSource {
	private ReloadableResourceBundleMessageSource reloadableResourceBundleMessageSource;
	private SessionLocaleResolver sessionLocaleResolver;

	public SessionLocaleResolver getSessionLocaleResolver() {
		return sessionLocaleResolver;
	}

	public void setSessionLocaleResolver(SessionLocaleResolver sessionLocaleResolver) {
		this.sessionLocaleResolver = sessionLocaleResolver;
	}
	
	/**
	 * getReloadableResourceBundleMessageSource() 
	 * @param reloadableResourceBundleMessageSource - resource MessageSource
	 * @return ReloadableResourceBundleMessageSource
	 */	
	public void setReloadableResourceBundleMessageSource(ReloadableResourceBundleMessageSource reloadableResourceBundleMessageSource) {
		this.reloadableResourceBundleMessageSource = reloadableResourceBundleMessageSource;
	}
	
	/**
	 * getReloadableResourceBundleMessageSource() 
	 * @return ReloadableResourceBundleMessageSource
	 */	
	public ReloadableResourceBundleMessageSource getReloadableResourceBundleMessageSource() {
		return reloadableResourceBundleMessageSource;
	}
	
	/**
	 * 정의된 메세지 조회
	 * @param code - 메세지 코드
	 * @return String
	 */	
	public String getMessage(String code) {
		return getReloadableResourceBundleMessageSource().getMessage(code, null, Locale.getDefault());
	}
	
	/**
	 * 
	 * @param code
	 * @param locale
	 * @return
	 */
	public String getMessage(String code, Locale locale) {
		return getReloadableResourceBundleMessageSource().getMessage(code, null, locale);
	} 
	
	/**
	 * 
	 * @param code
	 * @param request
	 * @return
	 */
	public String getMessage(String code, HttpServletRequest request) {
		return getReloadableResourceBundleMessageSource().getMessage(code, null, RequestContextUtils.getLocale(request));
	}
	
	/**
	 * 
	 * @param code
	 * @param arguments
	 * @return
	 */
	public String getMessage(String code, Object[] arguments) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, Locale.getDefault());
	}
	
	/**
	 * 
	 * @param code
	 * @param locale
	 * @param arguments
	 * @return
	 */
	public String getMessage(String code, Locale locale, Object[] arguments) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, locale);
	}
	
	/**
	 * 
	 * @param code
	 * @param request
	 * @param arguments
	 * @return
	 */
	public String getMessage(String code, HttpServletRequest request, Object[] arguments) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, RequestContextUtils.getLocale(request));
	}	
	
	/**
	 * 
	 * @param code
	 * @param arguments
	 * @param defaultMessage
	 * @return
	 */
	public String getMessage(String code, Object[] arguments, String defaultMessage) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, defaultMessage, Locale.getDefault());
	}
	
	/**
	 * 
	 * @param code
	 * @param locale
	 * @param arguments
	 * @param defaultMessage
	 * @return
	 */
	public String getMessage(String code, Locale locale, Object[] arguments, String defaultMessage) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, defaultMessage, locale);
	}
	
	/**
	 * 
	 * @param code
	 * @param request
	 * @param arguments
	 * @param defaultMessage
	 * @return
	 */
	public String getMessage(String code, HttpServletRequest request, Object[] arguments, String defaultMessage) {
		return getReloadableResourceBundleMessageSource().getMessage(code, arguments, defaultMessage, RequestContextUtils.getLocale(request));
	}	
}

