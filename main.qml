import QtQuick 2.14
import QtQuick.Controls 2.12
import QtQuick.Window 2.14
import QtWayland.Compositor 1.14

WaylandCompositor {
    id: comp
    WaylandOutput {
        compositor: comp
        sizeFollowsWindow: true
        window: Window {
            id: window
            width: 700
            height: 700
            visible: true
            Page {
                anchors.fill: parent
                header: TabBar {
                    id: tabBar
                    currentIndex: swipeView.currentIndex
                    Repeater {
                        model: shellSurfaces
                        TabButton {
                            text: modelData.title
                            WaylandQuickItem {
                                surface: modelData.surface
                                width: 32
                                height: 32
                                sizeFollowsSurface: false
                                enabled: false
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                            }
                        }
                    }
                }
            }
            SwipeView {
                id: swipeView
                currentIndex: tabBar.currentIndex
                anchors.fill: parent
                Repeater {
                    model: shellSurfaces
                    ShellSurfaceItem {
                        shellSurface: modelData
                        onSurfaceDestroyed: shellSurfaces.remove(index)
                    }
                }
            }
        }
    }
//    WlShell {
//        onWlShellSurfaceCreated:
//            shellSurfaces.append({shellSurface: shellSurface});
//    }
//    XdgShellV6 {
//        onToplevelCreated:
//            shellSurfaces.append({shellSurface: xdgSurface});
//    }
    XdgShell {
        onToplevelCreated:
            shellSurfaces.append({shellSurface: xdgSurface});
        //QtWayXdgSurfaceV5.sendConfigure: Qt.size(swipeView.width, swipeView.height);

    }
    ListModel { id: shellSurfaces }
}

