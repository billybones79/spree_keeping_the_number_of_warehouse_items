module Spree
  module Admin
    class ImportLogController < Spree::Admin::BaseController
      def index
         @import_logs = ImportLog.all().order("created_at desc")
      end
      def show
        @import_log = ImportLog.find(params[:id])
      end
    end
  end
end