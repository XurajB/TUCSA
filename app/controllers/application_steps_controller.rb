class ApplicationStepsController < ApplicationController
  include Wicked::Wizard
  steps :contact, :educational, :purpose, :send_recommendations, :complete
  
  def show
    @cs_application = current_user.cs_application
    case step
    when :contact
      if @cs_application.mailing_address.present?
        @contact = @cs_application.mailing_address
        puts 'found record......'
      else
        puts 'new record......'
        @contact = @cs_application.build_mailing_address
      end
    when :educational
      if @cs_application.institutions.present?
        @institution = @cs_application.institutions.first
      else
        @institution = @cs_application.institutions.build
      end
    when :purpose
      
    when :send_recommendations
      if @cs_application.recommendations.present?
        @recommendation = @cs_application.recommendations.first
      else
        @recommendation = @cs_application.recommendations.build
      end
    end
    render_wizard
  end
  
  def update
    @cs_application = current_user.cs_application
    case step
    when :contact
      @contact = MailingAddress.new(params[:mailing_address])
      @contact.cs_application_id = @cs_application.id
      @contact.save
      @cs_application.progress = 40
      @cs_application.is_citizen = params[:cs_application][:is_citizen]
      @cs_application.telephone = params[:cs_application][:telephone]
      @cs_application.save
    when :educational
      @institution = Institution.new(params[:institution])
      @institution.cs_application_id = @cs_application.id
      @institution.save
      @cs_application.progress = 60
      @cs_application.save
    when :purpose
      @cs_application.purpose_statement = params[:cs_application][:purpose_statement]
      @cs_application.progress = 70
      @cs_application.save
    when :send_recommendations
      @recommendation = Recommendation.new(params[:recommendation])
      @recommendation.cs_application_id = @cs_application.id
      @recommendation.save
      @cs_application.progress = 90
      @cs_application.save
    end
    
    #@cs_application.attributes = params[:cs_application]

    render_wizard @cs_application
  end
  
  
end
