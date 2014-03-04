class LiveConnectSyncer < Syncer
  def sync
    if needs_sync?(notebook)
      pages = notebook.pages.find_all { |p| needs_sync?(p) }
      pages.each do |p|
        mark_as_synced(p) if sync_page(p)
      end
    end
  end

  def sync_page(page)
    true
  end
end
