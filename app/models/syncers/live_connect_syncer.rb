class LiveConnectSyncer < Syncer
  def sync
    pages = notebook.pages.find_all { |p| needs_sync?(p) }
    pages.each do |page|
      sync_page(page)
    end
  end

  def sync_page(page)
    success = service.with_api(on_rescue: false) { |api| api.add_page(page) }
    !!success ? mark_synced(page) : mark_unsynced(page)
  end
end
