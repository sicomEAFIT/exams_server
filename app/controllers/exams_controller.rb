class ExamsController < ApplicationController
  def index
    @exams = Exam.all
  end

  def new
    @exam = Exam.new
  end

  def create
    @exam = Exam.new(exam_params)
    exam_pdf_path = create_pdf(@exam)
    @exam.pdf = File.open(exam_pdf_path)
    if @exam.save
      File.delete(exam_pdf_path)
      redirect_to exams_path, notice: "El examen \"#{@exam.name}\" se ha 
      subido."
    else
      render "new"
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    redirect_to exams_path, notice: "El examen \"#{@exam.name}\" se ha borrado."
  end

  private
    def exam_params
      params.require(:exam).permit(:name, :attachment)
    end

    def create_pdf(exam)
      exam_img_list = Magick::ImageList.new(exam.attachment.path())
      exam_pdf_path = Rails.root.join('public', 'uploads', 'tmp', 'pdfs', 
                                      exam.name + '.pdf')
      create_non_existing_dirs(exam_pdf_path)
      exam_img_list[0].write(exam_pdf_path)
      return exam_pdf_path
    end

    def create_non_existing_dirs(path)
      require 'fileutils'
      dirname = File.dirname(path)
      unless File.directory?(dirname)
        FileUtils.mkdir_p(dirname)
      end
    end
end
