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
        else
            puts"not saved"
        end
    end
  end
  