class RevertWorker
  include Sidekiq::Worker
    def perform(revert_to)

      log = ImportLog.find(revert_to)
      logs_to_revert = ImportLog.where("created_at >= ?", log.created_at).order(created_at: :desc)

      ActiveRecord::Base.delay_touching do

        ActiveRecord::Base.transaction do
          logs_to_revert.each do |l|
            l.revert
          end

        end
      end

      if log.message ==  "operation en cours."
        log.message = "Opération effectuée avec succès"
        log.save
      end
    end
  end