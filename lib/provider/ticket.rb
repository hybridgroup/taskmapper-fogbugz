module TaskMapper::Provider
  module Fogbugz
    # Ticket class for taskmapper-fogbugz
    #
    
    class Ticket < TaskMapper::Provider::Base::Ticket
      #API = Fogbugz::Ticket # The class to access the api's tickets
      # declare needed overloaded methods here
      
      def initialize(*object)
        if object.first
          object = object.first
          unless object.is_a? Hash
            @system_data = {:client => object}
            hash = {:id => object['ixBug'],
              :title => object['sTitle'],
              :description => object['sLatestTextSummary'], 
              :status => object['sStatus'],
              :project_id => object['ixProject'],
              :resolution => nil, 
              :requestor => nil,
              :priority => object['sPriority'],
              :assignee => object['sPersonAssignedTo'],
              :created_at => nil,
              :updated_at => object['dtLastUpdated']}
          else
            hash = object
          end
          super(hash)
        end
      end

      def id
        self['ixBug'].to_i
      end

      def title
        self['sTitle']
      end
      
      def title=(val)
        self['sTitle'] = val
      end

      def description 
        self['LatestTextSummary']
      end

      def project_id
        self['ixProject'].to_i
      end

      def resolution
        nil
      end

      def status
        self['sStatus']
      end

      def requestor
        nil
      end

      def priority
        self['sPriority']
      end

      def assignee
        self['sPersonAssignedTo']
      end

      def created_at
        nil
      end
      
      def project_id
        self["ixProject"]
      end

      def updated_at
        Time.parse(self['dtLastUpdated'])
      end

      def comments(*options)
        []
        warn "Fogbugz API doesn't support comments"
      end

      def comment(*options)
        nil
        warn "Fogbugz API doesn't support comments"
      end
      
      def self.create(attributes_hash)
        warn "Fogbugz Case doesn't not handle description'" if attributes_hash.has_key? :description
        
        options = translate attributes_hash, 
          :title => :sTitle,
          :priority => :ixPriority,
          :assignee => :ixPersonAssignedTo,
          :project_id => :ixProject
        
        new_case = TaskMapper::Provider::Fogbugz.api.command(:new, options)
                
        self.new options.merge :ixBug => new_case["case"]["ixBug"]
      end
      
      def save
        !update_case.has_key?("error")  
      end
      
      def self.find(project_id, options)
        if options.first.is_a? Array
          self.find_all(project_id).select do |ticket|
            options.first.any? { |id| ticket.id == id }
          end
        elsif options.first.is_a? Hash
          self.find_by_attributes(project_id, options.first)
        else
          self.find_all(project_id)
        end
      end

      def self.find_by_id(project_id, id)
        self.find_all(project_id).select { |ticket| ticket.id == id }.first
      end

      def self.find_by_attributes(project_id, attributes = {})
        search_by_attribute(self.find_all(project_id), attributes)
      end

      def self.find_all(project_id)
        tickets = []
        TaskMapper::Provider::Fogbugz.api.command(:search, :q => "project:=#{project_id}", :cols =>"dtLastUpdated,ixBug,sStatus,sTitle,sLatestTextSummary,ixProject,sProject,sPersonAssignedTo,sPriority").each do |ticket|
          tickets << ticket[1]["case"]
        end
        tickets.flatten.map { |xticket| self.new xticket }
      end
      
      private
        def update_case
          TaskMapper::Provider::Fogbugz.api.command :edit, to_case_hash
        end
        
        def self.translate(hash, mapping)
          Hash[hash.map { |k, v| [mapping[k] ||= k, v]}]
        end
        
        #just title until now
        def to_case_hash
          { 
            :ixBug => id,
            :sTitle => title 
          }
        end
    end
  end
end
