class LiveConnectSyncer < Syncer
  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }
    pages.each do |page|
      sync_page(page)
    end
  end

  def sync_page(page)
    service.api.add_page(page)
    mark_synced(page)
  rescue Service::InvalidRequest => e
    mark_unsynced(page)
  end
end
