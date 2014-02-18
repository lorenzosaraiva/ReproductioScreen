/*
 * Copyright (c) 2011-2013 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.2
import bb.multimedia 1.0

Page {
    id: topPage
	
    property variant currentMeeting: {
        "subject": "Assunto da reunião",
        "atendees": [ {
                "name": "p1@gmail.com",
                "color": "#FF3333"
            }, {
                "name": "p2@gmail.com",
                "color": "#415CB0"
            },
            {
                "name": "p3@gmail.com",
                "color": "#289FC5"
            } ],
        "startTime": "2/15/14 9:30 PM",
        "eventId": 1,
        "topics": [ {
                "name": "Tópico1",
                "duration": 20
            },
            {
                "name": "Topico2",
                "duration": 20
            } ],
        "topicsTime": [ {
                "name": "Tópico1",
                "startTime": 0
            },
            {
                "name": "Topico2",
                "startTime": 50
            } ],
        "atendeesTime": [ {
                "name": "p1@gmail.com",
                "startTime": 0
            },
            {
                "name": "p2@gmail.com",
                "startTime": 15
            },
            {
                "name": "p3@gmail.com",
                "startTime": 30
            },
            {
                "name": "p2@gmail.com",
                "startTime": 50
            },
            {
                "name": "p1@gmail.com",
                "startTime": 55
            }]
    }
    
    titleBar: TitleBar {
        title: "Meeting recording"
    }
    Container {
        
        attachedObjects: [
        	MediaPlayer{
        	    id: mediaPlayer
        	    sourceUrl:  "asset:///Music/Sail.mp3"
        	    onPositionChanged: {
        	        console.log("COMEÇOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
        	        
                for (var i = 0; i<adm.size(); i++){
                    var topicStartTime = adm.value(i).startTime;
                    //verifica se o ultimo
                    var topicFinalTime = ((i + 1) < adm.size()) ?  adm.value(i+1).startTime : (mediaPlayer.position+1)
                    console.log("PASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSO 1")
                    if( mediaPlayer.position >= topicStartTime*1000 && mediaPlayer.position < topicFinalTime*1000){
                        //var descobrir as pessoas
                        console.log("PASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSO 2")
                        for( var k =0; k < adm.value(i).people.length; k++ ){
                            var startTime = adm.value(i).people[k].peopleStartTime
                            var endTime = startTime + adm.value(i).people[k].timestamp
                            if( mediaPlayer.position >= (startTime*1000) && mediaPlayer.position < (endTime*1000) ){
                                console.log("THIS IS SPARTAAAAAAAAAAAAAAAAAAAAAA" + adm.value(i).people[k].peopleStartTime)
                                //var indexPath = adm.people[k].peopleStartTime.indexOf(startTime,0)
//                                topList.select(k,true)
                                
                            }
                            
                        }
                        
                    } 
                    
                   
                }
                
                
//                 for (var i = 0; i<currentMeeting.atendeesTime.length; i++){
//                     console.log(currentMeeting.atendeesTime[i].startTime)
////                     var inicialTime = currentMeeting.atendeesTime[i].startTime
//                     
//                     console.log("MEEEEEEEEEEEEEEEEEEEEEEEEIOOOOOOOOOOOOOOOOO")
//                     
//                     if (currentMeeting.atendeesTime[i].startTime*1000<=mediaPlayer.position && currentMeeting.atendeesTime[i+1].startTime*1000 > mediaPlayer.position){
//                       console.log("AQQQQQQQQQQQQQQQQUI")
//                       console.log(currentMeeting.atendeesTime[i].startTime)
//                       console.log(currentMeeting.atendeesTime[i+1].startTime)
//                       console..log(
//                       
//                        
//                    }
//                     console.log("POSITON CHANGEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEED")
//                 }
             }
        	}
        	
        ]

        ListView {
            id: topList
            dataModel: ArrayDataModel {
                id: adm
            }
            function playMedia(pos){
                
                if(mediaPlayer.bufferStatus!=BufferStatus.Playing){
                console.log("ENTROU NO IFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
                mediaPlayer.play()
        }
                mediaPlayer.seekTime(pos*1000)
            }
            onCreationCompleted: {

                for (var i = 0; i < currentMeeting.topicsTime.length; i ++) {
                    console.log("Tooooooooooooooopico:" + currentMeeting.topicsTime[i].name)
                    var people = [];
                    var topicStartTime = currentMeeting.topicsTime[i].startTime
                    
                    //Se nao for o ultimo elemento,pega o proximo
                    //Se for fica -1 indicando infinito
                    var topicFinalTime = ((i + 1) < currentMeeting.topicsTime.length) ?  currentMeeting.topicsTime[i + 1].startTime : -1
 
                    //descobre qual os elementos que estarão dentro do tópico
                    for (var j = 0; j < currentMeeting.atendeesTime.length; j ++) {
                        var currentAtendessStartTime = currentMeeting.atendeesTime[j].startTime
                        
                        //TODO: Pegar o final da reunião que ainda não temos neste momento
                        //BUG o ultimo elemento não terá a proporção certa
                        var currentAtendessEndTime = (topicFinalTime == -1? topicStartTime+1:topicFinalTime)
                        
                        //O final do elemento atual é o inicio do proximo. Se ele nao for o ultimo pega do proximo
                        if( (j+1) < currentMeeting.atendeesTime.length ) {
                            currentAtendessEndTime = currentMeeting.atendeesTime[j+1].startTime
                        }
                        var localTopicFinalTime = topicFinalTime;
                        
                        //usa um macete para o que no ultimo topico sempre dar positivo a comparacao com o final do topico
                        if (localTopicFinalTime == -1) localTopicFinalTime = currentAtendessStartTime + 1;
                        
                        var color = "#415CB0";
                        //descobre a cor
                        for (var k = 0; k < currentMeeting.atendees.length; k ++) {
                            if (currentMeeting.atendees[k].name == currentMeeting.atendeesTime[j].name) {
                                color = currentMeeting.atendees[k].color
                                break;
                            }
                        }
                       
                        if (currentAtendessStartTime >= topicStartTime && currentAtendessStartTime < localTopicFinalTime) {
                            console.log(currentMeeting.atendeesTime[j].name + " : " + (currentAtendessEndTime - currentAtendessStartTime) )
                            people.push({
                                    "nome": currentMeeting.atendeesTime[j].name,
                                    "timestamp": currentAtendessEndTime - currentAtendessStartTime ,
                                    "color": color,
                                    "peopleStartTime":currentAtendessStartTime
                            })
                        }
                    }

                    adm.insert(i, [
                            {
                                "topico": currentMeeting.topicsTime[i].name,
                                "startTime": topicStartTime,
                                "color": "#f5f5f5",
                                "people": people
                            } ]);

                }
            }
            listItemComponents: ListItemComponent {
                Container {
                    id: item
                    background: Color.create(ListItemData.color)
                    topPadding: 10
                    leftPadding: 20
                    rightPadding: 10
                    bottomPadding: 5
                    Label {
                        text: ListItemData.topico
                        textStyle.fontSize: FontSize.Large
                        textStyle.color: Color.create("#262626")
                    }
                    ListView {
                        id: subList
                        dataModel: ArrayDataModel {
                            id: admSub
                        }
                        //preferredHeight: 400
                        onCreationCompleted: {
                            admSub.append(ListItemData.people)
                            var totalSize = 0
                            for (var i = 0; i < admSub.size(); i ++) {

                                var item = admSub.value(i)

                                if (item.timestamp * 10) {
                                    totalSize += (item.timestamp * 10 > 110 ? item.timestamp * 10 : 110);
                                }
                            }

                            subList.preferredHeight = totalSize
                        }
                        listItemComponents: ListItemComponent {
                                                            
                            
                            Container {
                                id: subItem
                                layout: DockLayout {
                                }
                                
                                preferredWidth: 1280
                                preferredHeight: (ListItemData.timestamp * 10 > 110 ? ListItemData.timestamp * 10 : 110)
                                topPadding: 10
                                bottomPadding: 10
                                leftPadding: 10
                                background: ListItem.selected? Color.Black:Color.create(ListItemData.color)
                                Label {
                                    text: ListItemData.nome
                                    textStyle.color: Color.create("#F5F5F5")
                                    verticalAlignment: VerticalAlignment.Center
                                }
                                ListItem.onActivationChanged: {
                                    if (active) {
                                        subItem.opacity = 0.5
                                    } else
                                        subItem.opacity = 1
                                }
                                
                            }
                        
                        }
                        
                        onTriggered: {
                            clearSelection()
                            subList.select(indexPath,true)
                            var data = dataModel.data(indexPath)
                            item.ListItem.view.playMedia(data.peopleStartTime)
                            console.log(data.peopleStartTime)
                            console.log("CLIKEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEED")
                            
                        
                        }
                        
                    }
                    Container {
                        
                        Divider {
                        }
                    }
                    
                }
            }
            
        }
       
        
        Button {
            onClicked: {
                mediaPlayer.stop()
            }
        }   
    }
}
