class Report < ActiveRecord::Base
  belongs_to :working_shift
  attr_accessor :new_content

  def update_content(new_content, updating_id)
    updating = Time.now.strftime("%d/%b %H:%M:%S")
    username = User.find(updating_id).short_name
    if self.content
      temp = updating + " " + username + " updated:<br/>-- " + new_content + "<br/>"
      self.content = temp + self.content
    else
      temp = updating + " " + username + " created:<br/>-- " + new_content + "<br/>"
      self.content = temp
    end
    self.save!
  end
end
