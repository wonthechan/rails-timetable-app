class HomeController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	# 검색된 강좌들을 담고 있는 컬렉션 변수
	$filtered = nil
	
	def index
		### 루트 페이지 로드시 이루어지는 과정 ##
		# 항상 모든 강좌를 담고 있는 컬렉션 변수
		@courses_all = Course.all
		# 시간표에 등록된 강좌들만 담고 있는 변수 (시간표 그릴때 사용함)
		@courses_d = Course.where("display = ?", true)
		
		if $filtered != nil
			# $filtered가 인스턴스를 담고 있다면 해당 되는 강좌를 보여준다.
			@courses = $filtered
			$filtered = nil
		else
			# $filtered가 초기화 되어 있는 경우 모든 강좌를 보여준다.
			@courses = Course.all
		end
	end
		
	def result
		# 해당 쿼리문을 통해 검색 결과 강좌들을 받아와 $filtered에 저장한다.
		@searches = eval(params[:bulletin]).where("lecture like ? OR code like ? OR professor like ?", "%#{params[:search_text]}%", "%#{params[:search_text]}%", "%#{params[:search_text]}%")
		$filtered = @searches
		redirect_to '/'
  	end
	
	def register
		# 강의 등록 과정은 해당 강좌의 display 컬럼값을 true 또는 1 로 변경시킨다.
		target = Course.find(params[:course_id])
		registable = true
		
		if !target.display
			# 등록된 강의를 모두 불러옴
			courses_display = Course.where("display = ?", true)
			# 시간대가 중복되는지 확인하는 순회문
			courses_display.each do |course|
				# 등록하고자 하는 강의의 요일
				days_target = target.dayofweek.chars.to_a
				# 시간표에 등록된 강의의 요일
				days_course = course.dayofweek.chars.to_a
				# 두개의 강의가 중복되는 요일을 뽑아 days에 저장
				days = days_target & days_course
				if !days.empty?
					start_target = target.start_time
					end_target = target.end_time
					start_course = course.start_time
					end_course = course.end_time
					# 시간 check
					if !(start_target >= end_course or end_target <= start_course)
						# 서로 겹치는 경우 (에러발생: flash 알람 활성화)
						flash[:alert] = "해당 시간대에 중복되는 강의가 있습니다."
						registable = false
						break
					end
				end
			end
			
			if registable
				target.display = true
				target.save
			end
			
		else
			# 이미 등록된 강의일 경우 (에러발생: flash 알람 활성화)
			flash[:alert] = "이미 등록된 강의입니다."
		end
		redirect_back(fallback_location: root_path)
	end
	
	def delete
		# 등록 해제 과정 (해당 강의의 display 값을 false로 변경한다.)
		@target = Course.find(params[:course_id])
		@target.display = false
		
		# 등록 해제가 완료되면 delete.js.erb를 실행한다.
		if @target.save
			respond_to do |format|
				format.js
			end
    	end
	end
	
	def create_memo
		# 새로운 메모 생성 (title, content, course_id를 넘겨받는다.)
		# 해당 강의를 찾는다.
		@course = Course.find(params[:course_id])
		# 해당 강의를 참조하는 메모를 하나 생성한다.
		@memo = @course.memos.build(:title => params[:title], :content => params[:content])
		# 메모가 잘 생성되면 create_memo.js.erb를 실행한다.
		if @memo.save
			respond_to do |format|
				format.js
			end
    	end
	end
	
	def delete_memo
		# 해당 메모 삭제
		@target_memo = Memo.find(params[:memo_id])
		# 메모가 잘 삭제되면 delete_memo.js.erb를 실행한다.
		if @target_memo.destroy
			respond_to do |format|
				format.js
			end
    	end
	end
	
	def load_memos
		# 해당 강의의 모달창에 보여질 메모 리스트를 불러온다.
		@target_memos = Course.find(params[:target_id]).memos
		# 성공적으로 불러오면 load_memos.js.erb를 실행한다.
		respond_to do |format|
			format.js
		end
	end
	
	def get_target_course
		# 모달창에 보여질 강의 정보들을 불러온다.
		@target_course = Course.find(params[:target_id])
		# 해당 강의가 DB상에 존재하는 경우 강의 컬럼값을 JSON으로 전송한다.(ajax 요쳥 응답)
		if @target_course != nil
			render json: @target_course
		end
	end
	
end
