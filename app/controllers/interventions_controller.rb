class InterventionsController < ApplicationController
    protect_from_forgery except: :admin
    
    def index
        params.permit(:customer_id, :building_id, :battery_id, :column_id, :report, :employee_id, :elevator_id, :user_id)
    end

    def getBuilding
        buildings = Building.where(customer_id:params[:customer_id])
        render json:{buildingsReturn:buildings}
    end

    def getBattery
        batteries = Battery.where(building_id:params[:building_id])
        render json:{batteriesReturn:batteries}
    end

    def getColumn
        columns = Column.where(battery_id:params[:battery_id])
        render json:{columnsReturn:columns}
        puts current_user.employees[0].id
    end

    def getElevator
        elevators = Elevator.where(column_id:params[:column_id])
        render json:{elevatorsReturn:elevators}
    end

    def submit
        user_id = params[:user_id]
        employee = Employee.where(user_id: user_id)[0]
        @intervention = Intervention.new(

            customer_id:params[:customer_id],
            building_id:params[:building_id],
            battery_id:params[:battery_id],
            column_id:params[:column_id],
            elevator_id:params[:elevator_id],
            employee_id:params[:employee_id],
            author: employee.id
        )
        if @intervention.save
            puts"successfully saved"
            company_name = Customer.find(params[:customer_id]).company_name
            request_name = Employee.where(user_id: user_id)[0].first_name
            report = params[:report]
            building_id = params[:building_id]
            battery_id = params[:battery_id]
            column_string = ""
            elevator_string = ""
            employee_string = ""
            if params[:column_id].blank? == true
                column_string = ""
            else
                column_string = "at column #{params[:column_id]}"
            end
            
            if params[:elevator_id].blank? == true
                elevator_string = ""
            else
                elevator_string = "at elevator #{params[:elevator_id]}"
            end

            if params[:employee_id].blank? == true
                employee_string = ""
            else
                employee_string = "assign to #{params[:employee_id]}"
            end

            ZendeskAPI::Ticket.create!(@client, 
                :subject => "Intervention from #{company_name}",
                :requester => {"name": request_name},
                :comment => { :value => 
                 "There's an intervention from company #{company_name}.
                The intervention happens at building #{building_id}, at battery #{battery_id} #{column_string} #{elevator_string} #{employee_string}
                  Report: #{report}"},
                :type => "question",  
                :priority => "urgent")
        else
            puts"not saved"
        end
        
    end
  end
  