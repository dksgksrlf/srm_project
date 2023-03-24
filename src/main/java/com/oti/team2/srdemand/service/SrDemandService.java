package com.oti.team2.srdemand.service;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oti.team2.attachment.dto.AttachResponseDto;
import com.oti.team2.attachment.service.IAttachmentService;
import com.oti.team2.progress.service.IProgressService;
import com.oti.team2.srdemand.dao.ISrDemandDao;
import com.oti.team2.srdemand.dto.MytodoSrListDto;
import com.oti.team2.srdemand.dto.SdApprovalDto;
import com.oti.team2.srdemand.dto.SrDemand;
import com.oti.team2.srdemand.dto.SrFilterDto;
import com.oti.team2.srdemand.dto.SrRequestDto;
import com.oti.team2.srdemand.dto.SrdemandDetail;
import com.oti.team2.srinformation.dto.SrDmndRowNum;
import com.oti.team2.srinformation.service.ISrinformationService;
import com.oti.team2.util.pager.Pager;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class SrDemandService implements ISrDemandService {

	@Autowired
	private ISrDemandDao srDemandDao;

	@Autowired
	private ISrinformationService srinformationService;

	@Autowired
	private IProgressService progressService;

	@Autowired
	private IAttachmentService attachmentService;

	/**
	 * sr요청 등록
	 * 
	 * @author 신정은
	 */
	public int addSrDemand(SrRequestDto srRequestDto) throws IllegalStateException, IOException {

		// 요청번호 생성
		String dmndNo = createSrDemandCode();
		srRequestDto.setDmndNo(dmndNo);
		int row = srDemandDao.insertSrDemand(srRequestDto);

		if (srRequestDto.getAttachFile() != null) {
			attachmentService.uploadFiles(srRequestDto.getAttachFile(), 0, srRequestDto.getDmndNo());
		}
		log.info(row);
		return row;
	}

	/**
	 * sr요청 코드 생성하기 요청번호 생성 로직 ex) SR230222_0002 1. 오늘 날짜를 230222 형식으로 가져온다. 2.
	 * SR230222 ~ 로 시작하는 요청의 개수를 구한다. : 3개라고 가정 3. 3+1=4 -> 4번 요청임 4. 숫자를 4자리가 안된다면,
	 * 앞에 0을 채워서 4자리 수로 만든다.
	 * 
	 * @author 신정은
	 */
	private String createSrDemandCode() {
		// 현재 날짜 포맷하여 가져오기
		Date now = Calendar.getInstance().getTime();
		SimpleDateFormat formatter = new SimpleDateFormat("yyMMdd");
		String formatedNow = formatter.format(now);
		String srCode = "SR" + formatedNow;

		int count = srDemandDao.countByDmndNo(srCode + "%");

		// ex) SR230222-0008 에서 _ 뒤의 숫자 4자리를 세팅하는 로직
		String number = (count + 1) + "";
		while (number.length() < 4) {
			number = "0" + number;
		}

		srCode = srCode + "-" + number;
		log.info("sr요청코드 : " + formatedNow);
		log.info("오늘의 요청 수 : " + count);
		log.info("최종 sr요청코드 : " + srCode);
		return srCode;
	}

	/**
	 * 고객의 나의 sr요청 목록 조회
	 * 
	 * @author 신정은
	 */
	public List<SrDemand> getSrDemandList(String custId, Pager pager, String sort, SrFilterDto srFilterDto) {
		return srDemandDao.selectByCustId(custId, pager, sort, srFilterDto);
	}

	/**
	 * sr요청 수정 진행
	 * 
	 * @author 신정은
	 * @throws IOException
	 * @throws IllegalStateException
	 */
	public int updateSrDemand(SrRequestDto srRequestDto) throws IllegalStateException, IOException {
		int row = 0;
		srDemandDao.updateByDmndNo(srRequestDto);
		if(srRequestDto.getNattachFile() != null && srRequestDto.getNattachFile().get(0).getSize() != 0) {
			log.info("첨부파일 있어요");
			attachmentService.uploadFiles(srRequestDto.getNattachFile(), 0, srRequestDto.getDmndNo());
		}
		return 0;
	}

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-02-22
	 * @return sr요청 상세 조회
	 */
	public SrdemandDetail getSrDemandDetail(String dmndNo) {
		SrdemandDetail sd = srDemandDao.selectDetailByDmndNo(dmndNo);
		List<AttachResponseDto> alist = attachmentService.getAttachFiles(null, dmndNo);
		sd.setAttachFile(alist);
		log.info(sd);
		return sd;
	}

	/**
	 * SR요청 삭제하기
	 * 
	 * @author 신정은
	 */
	public void deleteSrdemand(String dmndNo) {
		srDemandDao.updateDelYnByDmndNo(dmndNo);
	}

	/**
	 * 고객용 나의 요청 총 행의 수 구하기
	 * 
	 * @author 신정은
	 */
	public int getCountClientSr(String clientId, SrFilterDto srFilterDto) {
		return srDemandDao.countByClientId(clientId, srFilterDto);
	}

	/**
	 * 관리자용 모든요청 총 행의 수 구하기
	 * 
	 * @author 신정은
	 */
	public int getCountAllSr(SrFilterDto srFilterDto) {
		return srDemandDao.countAllSrDemand(srFilterDto);
	}

	/**
	 * 관리자용 모든요청 목록 가져오기
	 * 
	 * @author 신정은
	 */
	public List<SrDemand> getSrDemandListBy(Pager pager, String sort, SrFilterDto srFilterDto) {
		return srDemandDao.selectAllSrDemand(pager, sort, srFilterDto);
	}

	/**
	 * 관리자의 sr요청 결재 기능 승인 / 반려 모두 진행
	 * 
	 * @author 신정은
	 */
	@Transactional
	public void getSrDemandApproval(SdApprovalDto sdApprovalDto) {
		if (sdApprovalDto.getVal() == 1) {
			// sr_information 데이터 삽입
			srinformationService.insertInformation(sdApprovalDto);
			log.info("sr no 가져와라 ~~~   " + sdApprovalDto.getSrNo());
			// progress 데이터 삽입
			List<String> pNames = new ArrayList<>();
			pNames.add("요구정의");
			pNames.add("분석/설계");
			pNames.add("구현");
			pNames.add("테스트");
			pNames.add("반영요청");
			pNames.add("운영반영");
			progressService.addProgress(sdApprovalDto.getSrNo(), pNames);

		}
		int row = srDemandDao.updateSttsCdAndRjctRsnByDmndNo(sdApprovalDto);
		log.info(row);

	}

	/**
	 * SR요청 번호로 시스템cd 가져오기
	 * 
	 * @author 신정은
	 */
	public String getSysCdByDmndNo(String dmndNo) {
		return srDemandDao.selectSysCdByDmndNo(dmndNo);
	}

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-02-28
	 * @return sr요청 진행사항 수정 : 진척률 수정 / 결제취소 처리 시에 사용 됨
	 */
	@Transactional
	public void updateSrDemandStts(String srNo, int sttsCd) {
		log.info("결과 ~~~~~~~~~~~~  " + srNo + "       " + sttsCd);
		int row = srDemandDao.updateSttsBySrNo(srNo, sttsCd);
		log.info("updateSrDemandStts 결과 ~~~~~~~~~~~~  " + row);
	}

	/**
	 * DMNO 로 SRNO 조회
	 * 
	 * @author 최은종
	 */
	public String getSrNo(String dmndNo) {
		String srNo = srDemandDao.selectBySrDmndNo(dmndNo);

		log.info(srNo);
		return srNo;
	}

	/*
	 * 나의 할일 페이징 처리 : 고객/ 관리자의 각 상태별 목록 조회시 페이징 객체 생성
	 * 
	 * @author 신정은
	 */
	public Pager getcountsByCustIdOrPicIdAndSttsCd(String custId, String picId, int sttsCd, int pageNo) {
		int totalRows = srDemandDao.countByCustIdOrPicIdAndSttsCd(custId, picId, sttsCd);
		Pager pager = new Pager(5, totalRows, pageNo);
		return pager;
	}

	/**
	 * 나의 할일 페이지 - 상태별, 고객/관리별 요청+진척 조회 목록 불러오기
	 * 
	 * @author 신정은
	 */
	public List<MytodoSrListDto> getMytodoSrList(String custId, String picId, int sttsCd, Pager pager) {
		return srDemandDao.selectByCustIdOrPicIdAndSttsCd(custId, picId, sttsCd, pager);
	}

	/*
	 * 나의 할일 페이징 처리 : [고객/ 관리자]의 각 상태별 목록 조회시 페이징 객체 생성
	 * 
	 * @author 신정은
	 */
	public Pager getcountsByEmpIdAndSttsCd(String empId, int sttsCd, int pageNo) {
		int totalRows = srDemandDao.countByEmpIdAndSttsCd(empId, sttsCd);
		Pager pager = new Pager(5, totalRows, pageNo);
		return pager;
	}

	/*
	 * 나의 할일 페이지 - 상태별, [개발자]별 자원정보 + 요청 + 진척 조회 목록 불러오기
	 * 
	 * @author 신정은
	 */
	public List<MytodoSrListDto> getMytodoSrListForDeveloper(String empId, int sttsCd, Pager pager) {
		return srDemandDao.selectByEmpIdAndSttsCd(empId, sttsCd, pager);
	}

	/**
	 * 반영요청 수락하기
	 * 
	 * @author 여수한
	 */
	@Override
	public void endSr(String dmndNo) {
		srDemandDao.updateSrdemandStts(dmndNo);

	}

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-03-15
	 * @return 사용자의 sr요청 목록 엑셀 다운로드
	 * @throws Exception
	 */
	public List<SrDemand> getMyExcelList(String memberId, String sort, SrFilterDto srFilterDto) {
		List<SrDemand> list = srDemandDao.selectMyInfoAllToExcel(memberId, sort, srFilterDto);
		return list;
	}

	private void setHeaderCS(CellStyle cs, Font font, Cell cell) {
		cs.setAlignment(CellStyle.ALIGN_CENTER);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		cs.setBorderTop(CellStyle.BORDER_THIN);
		cs.setBorderBottom(CellStyle.BORDER_THIN);
		cs.setBorderLeft(CellStyle.BORDER_THIN);
		cs.setBorderRight(CellStyle.BORDER_THIN);
		cs.setFillForegroundColor(HSSFColor.GREY_80_PERCENT.index);
		cs.setFillPattern(CellStyle.SOLID_FOREGROUND);
		setHeaderFont(font, cell);
		cs.setFont(font);
		cell.setCellStyle(cs);
	}

	private void setHeaderFont(Font font, Cell cell) {
		font.setBoldweight((short) 700);
		font.setColor(HSSFColor.WHITE.index);
	}

	private void setCmmnCS2(CellStyle cs, Cell cell) {
		cs.setAlignment(CellStyle.ALIGN_LEFT);
		cs.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		cs.setBorderTop(CellStyle.BORDER_THIN);
		cs.setBorderBottom(CellStyle.BORDER_THIN);
		cs.setBorderLeft(CellStyle.BORDER_THIN);
		cs.setBorderRight(CellStyle.BORDER_THIN);
		cell.setCellStyle(cs);
	}

	@Override
	public void SrDemandListdownload(List<SrDemand> list, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		SXSSFWorkbook wb = new SXSSFWorkbook();
		Sheet sheet = wb.createSheet();
		sheet.setColumnWidth((short) 0, (short) 1000);
		sheet.setColumnWidth((short) 1, (short) 4500);
		sheet.setColumnWidth((short) 2, (short) 7000);
		sheet.setColumnWidth((short) 3, (short) 8000);
		sheet.setColumnWidth((short) 4, (short) 15000);
		sheet.setColumnWidth((short) 5, (short) 2000);
		sheet.setColumnWidth((short) 6, (short) 3000);
		sheet.setColumnWidth((short) 7, (short) 3000);
		Row row = sheet.createRow(0);
		Cell cell = null;
		CellStyle cs = wb.createCellStyle();
		Font font = wb.createFont();
		cell = row.createCell(0);
		cell.setCellValue("SR진척목록 리스트");
		setHeaderCS(cs, font, cell);
		sheet.addMergedRegion(new CellRangeAddress(row.getRowNum(), row.getRowNum(), 0, 8));

		row = sheet.createRow(1);
		cell = null;
		cs = wb.createCellStyle();
		font = wb.createFont();

		cell = row.createCell(0);
		cell.setCellValue("번호");
		setCmmnCS2(cs, cell);

		cell = row.createCell(1);
		cell.setCellValue("요청번호");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(2);
		cell.setCellValue("제목");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(3);
		cell.setCellValue("관련시스템");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(4);
		cell.setCellValue("등록자");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(5);
		cell.setCellValue("소속");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(6);
		cell.setCellValue("진행상태");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(7);
		cell.setCellValue("등록일");
		setHeaderCS(cs, font, cell);

		cell = row.createCell(8);
		cell.setCellValue("완료요청일");
		setHeaderCS(cs, font, cell);

		int i = 2;
		int ii = 1;
		for (SrDemand SrDemand : list) {

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

			String dmndYmd = null;
			String endYmd = null;
			if (SrDemand.getDmndYmd() != null)
				dmndYmd = sdf.format(SrDemand.getDmndYmd());
			if (SrDemand.getCmptnDmndYmd() != null)
				endYmd = sdf.format(SrDemand.getCmptnDmndYmd());

			row = sheet.createRow(i);
			cell = null;
			cs = wb.createCellStyle();
			font = wb.createFont();

			cell = row.createCell(0);
			cell.setCellValue(ii);
			setCmmnCS2(cs, cell);

			cell = row.createCell(1);
			cell.setCellValue(SrDemand.getDmndNo());
			setCmmnCS2(cs, cell);

			cell = row.createCell(2);
			cell.setCellValue(SrDemand.getTtl());
			setCmmnCS2(cs, cell);

			cell = row.createCell(3);
			cell.setCellValue(SrDemand.getSysNm());
			setCmmnCS2(cs, cell);

			cell = row.createCell(4);
			cell.setCellValue(SrDemand.getCustNm());
			setCmmnCS2(cs, cell);

			cell = row.createCell(5);
			cell.setCellValue(SrDemand.getInstNm());
			setCmmnCS2(cs, cell);

			cell = row.createCell(6);
			cell.setCellValue(SrDemand.getSttsNm());
			setCmmnCS2(cs, cell);

			cell = row.createCell(7);
			cell.setCellValue(dmndYmd);
			setCmmnCS2(cs, cell);

			cell = row.createCell(8);
			cell.setCellValue(endYmd);
			setCmmnCS2(cs, cell);

			i++;
			ii++;
		}
		response.setHeader("Set-Cookie", "fileDownload=true; path=/");
		response.setHeader("Content-Disposition", String.format("attachment; filename=\"SrDemandList.xlsx\""));
		wb.write(response.getOutputStream());
	}

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-03-15
	 * @return 관리자의 sr요청목록 엑셀 다운로드
	 */
	@Override
	public List<SrDemand> getSrExcelList(String sort, SrFilterDto srFilterDto) {
		List<SrDemand> list = srDemandDao.selectAdAllSrDemand(sort, srFilterDto);
		return list;
	}

	/*
	 * 요청의 행번호 조회
	 * 
	 * @authoe 안한길
	 * 
	 * @return
	 */
	@Override
	public SrDmndRowNum getRownum(String dmndNo, String custId) {
		return srDemandDao.selectRowNumByDmndNo(dmndNo, custId);
	}

	@Override
	public SrDmndRowNum getRownum(int hstryId, String custId) {
		return srDemandDao.selectRowNumByHstryId(hstryId, custId);
	}
}