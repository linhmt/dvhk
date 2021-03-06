class Report < ActiveRecord::Base
  default_scope :order => "report_date desc"
  belongs_to :working_shift
  belongs_to :user, :foreign_key => "approved_by"
  attr_accessor :new_content
  before_save :update_report_date

  def self.reports(date = nil)
    if date.blank?
      #      Report.where("report_date >= date_add(curdate(), interval - 15 day)")
      Report.all
    else
      Report.where(:report_date => date.to_date)
    end
  end
  
  def update_content(params, updating_id)
    n_content = params[:new_content]
    self.is_active = params[:is_active].to_bool unless params[:is_active].nil?
    updating = Time.now.strftime("%d/%b %H:%M:%S")
    username = User.find(updating_id).short_name
    if n_content.length > 0
      if self.content
        temp = "<b>" + updating + " " + username + " updated:</b><br/>>>> " + n_content + "<br/>"
        self.content = temp + self.content
      else
        temp = "<b>" + updating + " " + username + " created:</b><br/>>>> " + n_content + "<br/>"
        self.content = temp
      end
    end
    if (self.is_active == false)
      self.approved_by = updating_id
    end
    self.save!
  end
  
  def update_report_date
    self.report_date = Date.today if self.report_date.nil?
    self.is_active = true if self.is_active.nil?
  end
end