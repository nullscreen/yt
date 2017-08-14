require 'spec_helper'
require 'yt/models/bulk_report_job'

describe Yt::BulkReportJob, :partner do

  describe '.bulk_reports' do
    describe 'given the bulk report job has bulk reports' do
      let(:job) { $content_owner.bulk_report_jobs.first }
      let(:report) { job.bulk_reports.first }

      it 'returns valid bulk reports' do
        expect(report.id).to be_a String
        expect(report.start_time).to be_a Time
        expect(report.end_time).to be_a Time
        expect(report.download_url).to be_a String
      end
    end
  end
end
