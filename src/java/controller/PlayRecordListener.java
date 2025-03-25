package controller;

import dao.TrackDAO;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionAttributeListener;
import jakarta.servlet.http.HttpSessionBindingEvent;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Web application lifecycle listener for tracking play counts.
 *
 * @author HP
 */
@WebListener
public class PlayRecordListener implements HttpSessionAttributeListener {

    private static final Logger logger = Logger.getLogger(PlayRecordListener.class.getName());

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        handlePlayTrackEvent(event);
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        handlePlayTrackEvent(event);
    }

    private void handlePlayTrackEvent(HttpSessionBindingEvent event) {
        // Check if this is a track play event
        if ("currentPlayingTrackId".equals(event.getName())) {
            try {
                // Get the track ID from the session attribute
                Object value = event.getValue();
                if (value != null && value instanceof Integer) {
                    int trackId = (Integer) value;

                    // Increment the play count in the database
                    TrackDAO trackDAO = new TrackDAO();
                    boolean success = trackDAO.incrementPlayCount(trackId);

                    if (success) {
                        logger.log(Level.INFO, "Incremented play count for track ID: {0}", trackId);
                    } else {
                        logger.log(Level.WARNING, "Failed to increment play count for track ID: {0}", trackId);
                    }
                }
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Error processing track play event", e);
            }
        }
    }
}
