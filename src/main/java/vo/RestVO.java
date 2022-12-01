package vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor // 모든 맴버변수를 매개변수로하고 초기화 하는 생성자
@NoArgsConstructor  // 매개변수 없는 Default 생성자
// => RTestController 에서 객체 Return Test에 사용함.  
public class RestVO {
	private int jno;
	private String chief;
	private String jname;
	private String note;
} 
