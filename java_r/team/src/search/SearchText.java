package search;

import org.rosuda.REngine.REXP;
import org.rosuda.REngine.REXPMismatchException;
import org.rosuda.REngine.Rserve.RConnection;
import org.rosuda.REngine.Rserve.RserveException;

public class SearchText {
	public String getRVersion() {
		String result = "";
		try {
			RConnection conn = new RConnection();
			conn.assign("msg", "우리가 사용하는 R 버전");
			REXP x = conn.eval("info <- paste(iconv(msg, 'CP949','UTF-8'), ' : ', R.version.string); info");
			result = x.asString();
			conn.close();
		} catch (RserveException e) {
			e.printStackTrace();
		} catch (REXPMismatchException e) {
			e.printStackTrace();
		}
		return result;
	}
}
