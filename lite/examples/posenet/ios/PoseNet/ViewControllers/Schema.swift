//
//  Schema.swift
//  PoseNet
//
//  Created by Apple  on 2020-10-24.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation


public class Schema{
    
    
    public func Schema()
    {
        workoutNames = []
    }
    
    private let fullbodyExercise: [String] = ["LEG EXTENSION CRUNCHES", "LEG CLIMBERS", "FROGGY CRUNCHES", "JUMPING JACKS", "BURPREES", "LEG EXTENSION CRUNCHES", "CLEANS","CLEANS", "CLEANS", "CLEANS", "CLEANS", "DEADLIFTS", "DEADLIFTS", "DEADLIFTS", "DEADLIFTS", "STIFF LEG DEADLIFT", "STIFF LEG DEADLIFT", "STIFF LEG DEADLIFT" , "PUSH-UPS", "WIDE ARM PUSH-UPS", "MILITARY PUSH-UPS", "DIAMOND PUSH-UPS"]
    private let lowerExercise: [String] = ["FORWARD LUNGES", "SQUATS", "SUMO SQUATS", "REVERSE LUNGES","LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "FRONT SQUATS", "DIAGONAL LUNGES RIGHT", "DIAGONAL LUNGES LEFT", "LUNGE AND TWIST", "KURTSY LUNGES", "STANDING LUNGES"]
    private let backExcercise: [String] = ["SINGLE-LEGGED DEADLIFTS", "CHIN-UP'S", "KETTLEBELL SWINGS", "WIDE GRIP PULL-UP'S", "ROMANIAN DEADLIFTS", "CLEAN & JERKS", "STIFF-LEGGED DEADLIFTS", "CLEANS", "BACK EXTENSIONS", "BENTOVER ROW", "HIGH-PULLS"]
    private let coreExcercise: [String] = ["SIT-UP'S", "STANDING SIDE-DIPS", "LEG CLIMBERS", "FROG CRUNCHES", "LEG EXTENSION CRUNCHES", "GET-Up'S", "RUSSIAN TWISTS", "SIDE-BRIDGES RIGHT", "SIDE-BRIDGES LEFT", "V-Up's", "PLANK"]
    private let plyometicExcercise: [String] = ["JUMPING JACKS", "BOX JUMPS", "BURPEES", "JUMP ROPES", "JUMP SQUATS", "OVERTIRE JUMPS", "LATERAL SKATER JUMPS", "SKATER JUMP LUNGES"]
    private let armExcercise: [String] = ["TRICEPS DIPS", "ARM CURL CRUNCHES LEFT","ARM CURL CRUNCHES RIGHT","MILITARY PUSH-UPS","SQUAT SHOULDER PRESSES"]
    private let chestExcercise: [String] = ["PUSH-Up'S", "INCLINE PUSH-Up'S","WIDE ARM PUSH-Up'S","KNEE PUSH-Up'S","DIAMOND PUSH-Up'S", "PUSH-Up'S & ROTATE", "DECLINE PUSH-Up'S", "CHEST DIPS"]
    private let chestlowercoreExercise: [String] = ["PUSH-Up's","FORWARD LUNGES","SIDE-BRIDGES RIGHT","WIDE ARM PUSH-Up's", "SQUATS", "SIDE-BRIDGES LEFT","BURPEES", "ONE-LEGGED DEADLIFTS", "RIGHT LEG CLIMBERS","DIAMOND PUSH-Up's", "LEFT LEG CLIMBERS", "SUMO SQUATS", "FROG CRUNCHES","PUSH-Up's & ROTATE", "LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "V-Up's", "KNEE PUSH-Up's"]
    private let lowerarmsExercise: [String] = ["FIGURE 8","FOREHAND STROKES", "BACKHAND STROKES","SERVICE"]
    private let chestplyoExercise: [String] = ["JUMPING JACKS","PUSH-Up's","SIDE-BRIDGES RIGHT","JUMP SQUATS","WIDE ARM PUSH-Up'S", "SIDE-BRIDGES LEFT","BURPEES", "ONE-LEGGED DEADLIFTS", "OVERTIRE JUMPS","RIGHT LEG CLIMBERS","DIAMOND PUSH-up's", "LEFT LEG CLIMBERS", "FROG CRUNCHES", "LATERAL SKATER JUMPS", "PUSH-Up's & ROTATE", "V-Up's", "JUMPING JACKS"]
    private let superset1: [String] = ["INCLINE PUSH-Up's", "JUMP SQUATS", "DUMBBELL SNATCH", "LEG EXTENSION CRUNCHES", "CHIN-Up's","LATERAL SKATER JUMPS"]
    private let pushpullExercise: [String] = ["PUSH-Up'S", "CHIN-Up'S", "WIDE ARM PUSH-Up'S", "WIDE GRIP PULL-Up'S", "MILITARY PUSH-Up'S", "ONE-LEGGED DEADLIFTS", "INCLINE PUSH-UP'S","KETTLEBELL SWINGS", "DIAMOND PUSH-Up'S"]
    private let athleticConditioningExercise: [String] = ["JUMPING JACKS", "SUMO SQUATS", "SINGLE-LEGGED DEADLIFTS", "PUSH-Up'S", "FORWARD LUNGES", "TRICEPS DIPS", "CHIN-Up's", "SQUAT SHOULDER PRESSES", "LEG EXTENSION CRUNCHES" , "REVERSE LUNGES"]
    private let legandarmsExercise: [String]  = ["FORWARD LUNGES", "TRICEPS DIPS", "SQUATS", "MILITARY PUSH-Up'S", "SUMO SQUATS", "SQUAT SHOULDER PRESSES","REVERSE LUNGES", "WIDE ARM PUSH-Up's","LATERAL LUNGES RIGHT", "LATERAL LUNGES LEFT", "CHIN-Up'S", "FRONT SQUATS", "WIDE ARM PULL-UP's"]
    private let boxingExercise: [String] = ["SKIPPING ROPE","JAB, CROSS", "JAB, CROSS, LEFT HOOK", "JAB, CROSS, CROSS", "JAB, JAB, CROSS", "RIGHT HOOK, LEFT HOOK", "JAB, RIGHT UPPER CUT", "JAB, CROSS, LEFT UPPER CUT, RIGHT HOOK", "LEG EXTENSION CRUNCHES", "STANDING SIDE DIPS","SIDE-BRIDGES RIGHT", "SIDE-BRIDGES LEFT", "V-Up's"]
    private let dancingExercise: [String] = ["ONE TWO STEP", "FREESTYLE DANCE", "BELLY DANCING"]
    private let golfExercise: [String] = ["WEDGE", "6 IRON", "7 IRON", "DRIVER"]
    
    public var workoutNames: [String] = []
    
    public func getCurrentExerName (_ setNum: Double) -> String
    {
      if(setNum >= 1)
        {
            return workoutNames[(Int(setNum) - 1) % workoutNames.count]
        }
        else{
            return workoutNames[(workoutNames.count - Int(setNum) - 1) % workoutNames.count]
        }
    }
    
    public func createSuperSet(_ superSetName: String)
    {
        if (superSetName.elementsEqual("ARMS AND SHOULDERS"))
        {
            workoutNames = armExcercise
        }
        else if (superSetName.elementsEqual("LEGS FOR DAYS"))
        {
            workoutNames = lowerExercise
        }
        else if (superSetName.elementsEqual("BACK STRENGTH"))
        {
            workoutNames = backExcercise
        }
        else if (superSetName.elementsEqual("BEST CHEST"))
        {
            workoutNames = chestExcercise
        }
        else if (superSetName.elementsEqual("HIGH INTENSITY INTERVALS"))
        {
            workoutNames = plyometicExcercise
        }
        else if (superSetName.elementsEqual("ABS NO KABABS"))
        {
            workoutNames = coreExcercise
        }
        else if (superSetName.elementsEqual("FULL BODY WEIGHT"))
        {
            workoutNames = chestlowercoreExercise
        }
        else if (superSetName.elementsEqual("FULL BODY AGILITY"))
        {
            workoutNames = chestplyoExercise
        }
        else if (superSetName.elementsEqual("TENNIS SPECIAL"))
        {
            workoutNames = lowerarmsExercise
        }
        else if (superSetName.elementsEqual("ARMY SUPERSET"))
        {
            workoutNames = superset1
        }
        else if (superSetName.elementsEqual("GOLF SPECIAL"))
        {
            workoutNames = golfExercise
        }
        else if (superSetName.elementsEqual("DANCY DANCE"))
        {
            workoutNames = dancingExercise
        }
        else if (superSetName.elementsEqual("PUSH PULL"))
        {
            workoutNames = pushpullExercise
        }
        else if (superSetName.elementsEqual("ARMS AND LEGS"))
        {
            workoutNames = legandarmsExercise
        }
        else if (superSetName.elementsEqual("BOXING SPECIAL"))
        {
            workoutNames = boxingExercise
        }
        else if (superSetName.elementsEqual("ATHLETIC CONDITIONING"))
        {
            workoutNames = athleticConditioningExercise
        }
        else if (superSetName.elementsEqual("FULL BODY STRENGTH"))
        {
            workoutNames = fullbodyExercise
        }
    }
    
}
