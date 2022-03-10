package cubox.admin.schedule.service;

import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Date;
import java.util.Enumeration;

import javax.annotation.Resource;

import org.apache.commons.lang.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import cubox.admin.cmmn.util.CommonUtils;
import cubox.admin.cmmn.util.StringUtil;

@Service("scheduleResve")
public class ScheduleResve {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleResve.class);
	private String SRV_GB = System.getenv("FRS_ACTIVE"); //System.getProperty("spring.profiles.active");
	
	@Resource(name="commonUtils")
	private CommonUtils commonUtils;
	
	@Resource(name="ScheduleService")
	private ScheduleService scheduleService;

	public ScheduleResve(){
		String ip = getLocalServerIp();
		LOGGER.info("######### SRV_GB:{}, IP:{}", SRV_GB, ip);
	}	
	
	public void batchGlryDayStat() throws Exception {
		if(StringUtil.nvl(SRV_GB).equals("local")) return;
		
		String sBaseDe = commonUtils.getStringDate(DateUtils.addDays(new Date(), -1), "yyyy-MM-dd");
		
		LOGGER.debug("######### [batchGlryDayStat] start sBaseDe:{}", sBaseDe);
		int cnt = scheduleService.insertStatGlryDay(sBaseDe);
		LOGGER.debug("######### [batchGlryDayStat] end!! sBaseDe:{}, 처리건수:{}", sBaseDe, cnt);
	}
	
	public void batchCrttDayStat() throws Exception {
		if(StringUtil.nvl(SRV_GB).equals("local")) return;
		
		String sBaseDe = commonUtils.getStringDate(DateUtils.addDays(new Date(), -1), "yyyy-MM-dd");
		
		LOGGER.debug("######### [batchCrttDayStat] start sBaseDe:{}", sBaseDe);
		int cnt = scheduleService.insertStatCrttDay(sBaseDe);
		LOGGER.debug("######### [batchCrttDayStat] end!! sBaseDe:{}, 처리건수:{}", sBaseDe, cnt);		
	}
		
	private String getLocalServerIp(){
		String ip = "";
		try {
			Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
			while (interfaces.hasMoreElements()) {
				NetworkInterface iface = interfaces.nextElement();
				// filters out 127.0.0.1 and inactive interfaces
				if (iface.isLoopback() || !iface.isUp())
					continue;
				Enumeration<InetAddress> addresses = iface.getInetAddresses();
				while(addresses.hasMoreElements()) {
					InetAddress addr = addresses.nextElement();
					// *EDIT*
					if (addr instanceof Inet6Address) continue;
					ip = addr.getHostAddress();
					//LOGGER.debug(iface.getDisplayName() + " " + ip);
				}
			}
		} catch(SocketException e) {
			throw new RuntimeException(e);
		}
		return ip;
	}

}