class ExamsController < ApplicationController
  def index
    @exams = Exam.all
  end

  def show
    @exam = Exam.find(params[:id])
    @pages = @exam.pages.all
  end

  def new
    @exam = Exam.new
    @page = @exam.pages.build
  end

  # This method stores an exam and associates it to a pdf file in case the file
  # had been successfully created.
  def create
    @exam = Exam.new(exam_params)
    if params[:pages]
      if @exam.save
        params[:pages]['image'].each do |p|
          @exam.pages.create!(:image => p, :exam_id => @exam.id)
        end
        exam_pdf_path = create_pdf(@exam)
        @exam.pdf = File.open(exam_pdf_path)
        if @exam.save
          File.delete(exam_pdf_path)
          redirect_to exams_path, notice: "El examen \"#{@exam.name}\" se ha 
          subido."
        else
          @exam.destroy
          render json: {
            success: false,
            errors: "No fue posible guardar el archivo."
          }
        end
      else
        render "new"
      end
    else
      render json: {
        success: false,
        errors: "Se debe adjuntar al menos una imagen."
      }
    end
  end

  def destroy
    @exam = Exam.find(params[:id])
    @exam.destroy
    redirect_to exams_path, notice: "El examen \"#{@exam.name}\" se ha borrado."
  end

  private
    def exam_params
      params.require(:exam).permit(:name, pages_attributes: [:number, :image])
    end

    # This method writes the images array to a pdf file and returns its 
    # location path.
    def create_pdf(exam)
      exam_pdf_path = Rails.root.join('public', 'uploads', 'tmp', 'pdfs', 
                                      exam.name + '.pdf')
      create_non_existing_dirs(exam_pdf_path)
      images_array = Array.new
      exam.pages.each do |p|
        images_array.push p.image.path()
      end
      image_list = Magick::ImageList.new(*images_array)
      image_list.write(exam_pdf_path)

      return exam_pdf_path
    end

    # This method creates any non existing directory in the pdf path so that the 
    #  file can be stored.
    def create_non_existing_dirs(path)
      require 'fileutils'
      dir_name = File.dirname(path)
      unless File.directory?(dir_name)
        FileUtils.mkdir_p(dir_name)
      end
    end
end
