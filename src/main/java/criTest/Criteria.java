package criTest;

import lombok.Getter;
import lombok.ToString;

// ** Paging 을 하려면 ... ** 
// => 1Page 에 출력할 Row 갯수 설정 : 10개 
// => 현재 출력하고 있는 Page 
// => 출력할 List 가 기본적으로 필요.(Rows) 
//	 -> Start Row 순서번호 : 설정하기위해 계산이 필요함. 
// => 위의 기능들은 Criteria Class 에 정의함

// => 1Page 에 출력하는 PageNo 갯수 : 10개 
// 	 -> PageBlock 의 First Page No 
//	 -> PageBlock 의 Last Page No 
//	 -> 버튼 ( 앞으로 , 뒤로 ) / 1Page는 앞으로 버튼이 필요 없음. 
//	 -> Go 전체 페이지의 First Page 표시 여부 
//	 -> Go 전체 페이지의 Last Page 표시 여부
// => 위의 기능들은 PageMaker Class 로 처리함.

// ** Criteria : (판단이나 결정을 위한) 기준
// => 출력할 Row 를 설정 하기 위한 클래스
// => 이것을 위한 기준 값들을 관리함.

// ** PageMaker : UI에 필요한 정보를 완성한다.

@Getter
@ToString
public class Criteria {
	private int rowsPerPage; // 페이지당 출력 할 Row 갯수
	private int currPage; // 현재 페이지 (출력할 페이지)
	private int sno; 		 // Start RowNo
	private int eno;		 // End RowNo (MySql 은 없어도 됨)
	
	// 1) 필요한 초기값은 생성자로 초기화
	public Criteria() {
		this.rowsPerPage = 5;
		this.currPage = 1;
	}
	
	// 2) setCurrPage : 요청받은(출력할) PageNo set
	public void setCurrPage(int currPage) {
		if (currPage > 1) this.currPage = currPage;
		else this.currPage = 1;
	}
	// 3) setRowsPerPage
	// => 1페이지당 보여줄 Row(Record, 튜플) 갯수 확인
	// => 제한조건 점검 ( 50개 까지만 허용 )
	// => 당장은 사용하지 않지만 사용 가능하도록 작성
	public void setRowsPerPage(int rowsPerPage) {
		if ( rowsPerPage > 5 && rowsPerPage <= 50 )
			this.rowsPerPage = rowsPerPage;
		else this.rowsPerPage = 5;
	}
	
	// 4) setSnoEno : sno, eno 계산
	// => currPage, rowsPerPage 를 이용해 계산
	// => Oracle 검색조건 : Between(sno, eno) -> sno 부터 eno 까지
	// => MySql 검색조건 : limit (sno , n) -> sno+1 부터 n개
	public void setSnoEno() {
		if ( this.sno < 1 ) this.sno = 1; 
		// this.sno = (this.currPage - 1) * this.rowsPerPage + 1; -> Oracle 에 적합함.
		this.sno = (this.currPage - 1) * this.rowsPerPage; // MySql에 적합함.
		this.eno = this.sno + this.rowsPerPage - 1;		   // MySql 에서는 필수적이진 않음.
	}
	
	
	
} // class
